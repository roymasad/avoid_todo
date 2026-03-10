import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:icloud_storage/icloud_storage.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'database_helper.dart';
import 'google_account_helper.dart';
import 'app_crash_reporter.dart';

/// Cloud sync helper: uploads / downloads the SQLite DB to the user's own
/// cloud storage (iCloud on iOS, Google Drive on Android).
///
/// **Native setup required before this has any visible effect:**
/// - iOS:  add the iCloud Documents entitlement + container ID in Xcode, and
///         set [_iCloudContainerId] to your app's iCloud container identifier.
/// - Android:  configure a Google Cloud project with Drive API enabled, add the
///             OAuth 2.0 client ID to `android/app/src/main/res/values/strings.xml`,
///             and supply the SHA-1 fingerprint in the Cloud Console.
///
/// All public methods swallow errors silently — sync is best-effort.
class SyncHelper {
  SyncHelper._();

  static const String _dbFileName = 'todo.db';

  /// Replace with your iCloud container identifier (e.g. "iCloud.com.yourapp.avoid").
  static const String _iCloudContainerId = 'iCloud.com.roymassaad.avoidtodo';

  static const String _driveFileName = 'avoid_todo_backup.db';
  static const String _prefLastSync = 'last_sync_timestamp';
  static const String _prefLastAttempt = 'last_sync_attempt';

  /// Throttle: upload at most once every 10 minutes.
  static const int _syncThrottleMs = 10 * 60 * 1000;

  // ─────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────

  /// Whether cloud sync is supported on the current platform.
  static bool get isSupported => Platform.isIOS || Platform.isAndroid;

  /// Returns the last successful sync timestamp, or `null` if never synced.
  static Future<DateTime?> lastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_prefLastSync);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// Uploads the DB to cloud — throttled to [_syncThrottleMs] unless
  /// [force] is `true` (used by the manual "Back up now" button).
  ///
  /// Returns `true` on a successful upload, `false` if throttled or on error.
  static Future<bool> uploadIfNeeded({bool force = false}) async {
    if (!isSupported) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!force) {
        final lastAttempt = prefs.getInt(_prefLastAttempt) ?? 0;
        final elapsed = DateTime.now().millisecondsSinceEpoch - lastAttempt;
        if (elapsed < _syncThrottleMs) return false;
      }

      await prefs.setInt(
          _prefLastAttempt, DateTime.now().millisecondsSinceEpoch);
      final dbFile = await _getDbFile();
      if (!await dbFile.exists()) return false;

      if (Platform.isIOS) {
        await _iCloudUpload(dbFile);
      } else {
        await _driveUpload(dbFile);
      }

      await prefs.setInt(_prefLastSync, DateTime.now().millisecondsSinceEpoch);
      debugPrint('[SyncHelper] upload complete');
      return true;
    } catch (e) {
      debugPrint('[SyncHelper] upload error: $e');
      await AppCrashReporter.instance.recordError(
        e,
        StackTrace.current,
        reason: 'sync_upload',
      );
      return false;
    }
  }

  /// Downloads the latest backup from cloud regardless of age.
  ///
  /// Returns a [File] in the temp directory if a backup exists, or `null` if
  /// no backup is found. Caller should confirm with the user before restoring.
  static Future<File?> downloadLatestBackup() async {
    if (!isSupported) return null;
    try {
      if (Platform.isIOS) {
        return await _iCloudDownloadLatest();
      } else {
        return await _driveDownloadLatest();
      }
    } catch (e) {
      debugPrint('[SyncHelper] downloadLatestBackup error: $e');
      await AppCrashReporter.instance.recordError(
        e,
        StackTrace.current,
        reason: 'sync_download_latest_backup',
      );
      return null;
    }
  }

  /// Returns `true` if a backup file exists in the cloud (regardless of age).
  /// Useful for disambiguating the `null` return from [checkForNewerBackup].
  static Future<bool> hasRemoteBackup() async {
    if (!isSupported) return false;
    try {
      if (Platform.isIOS) {
        final files =
            await ICloudStorage.gather(containerId: _iCloudContainerId);
        return files.any((f) => f.relativePath == _dbFileName);
      } else {
        final api = await _driveApi();
        if (api == null) return false;
        final list = await _driveListBackups(api);
        return list.files != null && list.files!.isNotEmpty;
      }
    } catch (e) {
      debugPrint('[SyncHelper] hasRemoteBackup error: $e');
      await AppCrashReporter.instance.recordError(
        e,
        StackTrace.current,
        reason: 'sync_has_remote_backup',
      );
      return false;
    }
  }

  /// Replaces the local DB with [backupFile].
  ///
  /// ⚠️ The caller must hot-restart or re-init the DB connection after this.
  static Future<void> restoreFromBackup(File backupFile) async {
    try {
      final dbFile = await _getDbFile();
      // 1. Close and null the singleton reference FIRST so subsequent
      //    DatabaseHelper calls open a fresh connection, not the dead one.
      await DatabaseHelper.closeAndReset();
      // 2. Delete the old file (databaseFactory handles any remaining locks)
      await databaseFactory.deleteDatabase(dbFile.path);
      // 3. Copy the backup into place
      await backupFile.copy(dbFile.path);
      debugPrint('[SyncHelper] restore complete');
    } catch (e) {
      debugPrint('[SyncHelper] restoreFromBackup error: $e');
      await AppCrashReporter.instance.recordError(
        e,
        StackTrace.current,
        reason: 'sync_restore_from_backup',
      );
    }
  }

  static Future<bool> deleteRemoteBackup() async {
    if (!isSupported) return false;
    try {
      if (Platform.isIOS) {
        final files =
            await ICloudStorage.gather(containerId: _iCloudContainerId);
        if (files.every((f) => f.relativePath != _dbFileName)) return true;
        await ICloudStorage.delete(
          containerId: _iCloudContainerId,
          relativePath: _dbFileName,
        );
      } else {
        final api = await _driveApi();
        if (api == null) return false;
        final list = await _driveListBackups(api);
        final files = list.files ?? const <drive.File>[];
        for (final file in files) {
          final fileId = file.id;
          if (fileId == null) continue;
          await api.files.delete(fileId);
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefLastSync);
      debugPrint('[SyncHelper] remote backup deleted');
      return true;
    } catch (e) {
      debugPrint('[SyncHelper] deleteRemoteBackup error: $e');
      await AppCrashReporter.instance.recordError(
        e,
        StackTrace.current,
        reason: 'sync_delete_remote_backup',
      );
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // DB file path
  // ─────────────────────────────────────────────────────────────

  static Future<File> _getDbFile() async {
    final dir = await getDatabasesPath();
    return File(p.join(dir, _dbFileName));
  }

  // ─────────────────────────────────────────────────────────────
  // iOS — iCloud Documents
  // ─────────────────────────────────────────────────────────────

  static Future<void> _iCloudUpload(File dbFile) async {
    await ICloudStorage.upload(
      containerId: _iCloudContainerId,
      filePath: dbFile.path,
      destinationRelativePath: _dbFileName,
    );
  }

  static Future<File?> _iCloudDownloadLatest() async {
    final files = await ICloudStorage.gather(containerId: _iCloudContainerId);
    if (files.every((f) => f.relativePath != _dbFileName)) return null;
    final tmpDir = await getTemporaryDirectory();
    final dest = File(p.join(tmpDir.path, 'avoid_cloud_backup.db'));
    await ICloudStorage.download(
      containerId: _iCloudContainerId,
      relativePath: _dbFileName,
      destinationFilePath: dest.path,
    );
    return dest;
  }

  // ─────────────────────────────────────────────────────────────
  // Android — Google Drive
  // ─────────────────────────────────────────────────────────────

  static Future<drive.DriveApi?> _driveApi({bool interactive = true}) async {
    final session =
        await GoogleAccountHelper.backupDriveSession(interactive: interactive);
    return session?.api;
  }

  static Future<void> _driveUpload(File dbFile) async {
    final api = await _driveApi();
    if (api == null) return;

    final existing = await _driveListBackups(api);

    final bytes = await dbFile.readAsBytes();
    final media = drive.Media(
      Stream.value(bytes),
      bytes.length,
      contentType: 'application/octet-stream',
    );

    if (existing.files != null && existing.files!.isNotEmpty) {
      await api.files.update(
        drive.File(),
        existing.files!.first.id!,
        uploadMedia: media,
      );
    } else {
      await api.files.create(
        drive.File()
          ..name = _driveFileName
          ..parents = ['appDataFolder'],
        uploadMedia: media,
      );
    }
  }

  static Future<File?> _driveDownloadLatest() async {
    final api = await _driveApi();
    if (api == null) return null;

    final list = await _driveListBackups(api);
    if (list.files == null || list.files!.isEmpty) return null;
    return await _driveDownloadFile(api, list.files!.first.id!);
  }

  static Future<drive.FileList> _driveListBackups(drive.DriveApi api) {
    return api.files.list(
      q: "name='$_driveFileName' and trashed=false",
      spaces: 'appDataFolder',
      $fields: 'files(id)',
    );
  }

  static Future<File?> _driveDownloadFile(
      drive.DriveApi api, String fileId) async {
    final response = await api.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final tmpDir = await getTemporaryDirectory();
    final dest = File(p.join(tmpDir.path, 'avoid_cloud_backup.db'));
    final sink = dest.openWrite();
    await response.stream.pipe(sink);
    await sink.close();
    return dest;
  }
}
