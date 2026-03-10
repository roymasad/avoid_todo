import 'dart:convert';
import 'dart:io';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/trial_status.dart';
import 'google_account_helper.dart';
import 'icloud_kv_store.dart';

abstract class TrialRepository {
  static TrialRepository? create() {
    if (Platform.isIOS) return _ICloudTrialRepository();
    if (Platform.isAndroid) return _GoogleDriveTrialRepository();
    return null;
  }

  Future<bool> isAvailableForTrial();
  Future<TrialStatus?> loadStatus();
  Future<TrialStartResult> startTrial();
  Future<bool> clearStatus();
  Future<bool> expireStatus();
  Future<TrialDebugState> debugState();
}

abstract class _CachedTrialRepository implements TrialRepository {
  static const String _cachePrefKey = 'trial_status_cache_v1';

  Future<TrialStatus?> loadCachedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cachePrefKey);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return null;
    return TrialStatus.fromJson(decoded);
  }

  Future<void> cacheStatus(TrialStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachePrefKey, jsonEncode(status.toJson()));
  }

  Future<bool> hasCachedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_cachePrefKey);
  }

  Future<void> clearCachedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachePrefKey);
  }
}

class TrialDebugState {
  const TrialDebugState({
    required this.storageLabel,
    required this.isStorageAvailable,
    required this.hasCachedStatus,
    required this.status,
  });

  final String storageLabel;
  final bool isStorageAvailable;
  final bool hasCachedStatus;
  final TrialStatus? status;
}

class _ICloudTrialRepository extends _CachedTrialRepository {
  static const String _storageLabel = 'iCloud Key-Value Store';

  @override
  Future<bool> isAvailableForTrial() {
    return ICloudKvStore.isAvailable();
  }

  @override
  Future<TrialStatus?> loadStatus() async {
    final cached = await loadCachedStatus();
    try {
      if (!await ICloudKvStore.isAvailable()) return cached;
      final raw = await ICloudKvStore.getString(TrialStatus.storageKey);
      if (raw == null) return cached;
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return cached;
      final status = TrialStatus.fromJson(decoded);
      if (status == null) return cached;
      final refreshed = status.refreshed(DateTime.now().toUtc());
      if (refreshed.lastSeenAtUtc != status.lastSeenAtUtc) {
        await ICloudKvStore.setString(
          TrialStatus.storageKey,
          jsonEncode(refreshed.toJson()),
        );
      }
      await cacheStatus(refreshed);
      return refreshed;
    } catch (_) {
      return cached;
    }
  }

  @override
  Future<TrialStartResult> startTrial() async {
    try {
      if (!await ICloudKvStore.isAvailable()) {
        return const TrialStartResult(outcome: TrialStartOutcome.unavailable);
      }

      final existing = await loadStatus();
      if (existing != null) {
        return TrialStartResult(
          outcome: existing.isActive
              ? TrialStartOutcome.activeExisting
              : TrialStartOutcome.expiredExisting,
          status: existing,
        );
      }

      final started = TrialStatus.start(
        nowUtc: DateTime.now().toUtc(),
        accountKey: 'icloud_kv_store',
        source: TrialSource.iCloudKvStore,
      );
      final wrote = await ICloudKvStore.setString(
        TrialStatus.storageKey,
        jsonEncode(started.toJson()),
      );
      if (!wrote) {
        return const TrialStartResult(outcome: TrialStartOutcome.failed);
      }
      await cacheStatus(started);
      return TrialStartResult(
        outcome: TrialStartOutcome.started,
        status: started,
      );
    } catch (_) {
      return const TrialStartResult(outcome: TrialStartOutcome.failed);
    }
  }

  @override
  Future<bool> clearStatus() async {
    await clearCachedStatus();
    try {
      if (!await ICloudKvStore.isAvailable()) return true;
      return await ICloudKvStore.remove(TrialStatus.storageKey);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> expireStatus() async {
    try {
      final status = await loadStatus();
      if (status == null) return false;
      final now = DateTime.now().toUtc();
      final expired = status.copyWith(
        expiresAtUtc: now.subtract(const Duration(seconds: 1)),
        lastSeenAtUtc: now,
      );
      final wrote = await ICloudKvStore.setString(
        TrialStatus.storageKey,
        jsonEncode(expired.toJson()),
      );
      if (!wrote) return false;
      await cacheStatus(expired);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<TrialDebugState> debugState() async {
    final available = await ICloudKvStore.isAvailable();
    final hasCache = await hasCachedStatus();
    final status = await loadStatus();
    return TrialDebugState(
      storageLabel: _storageLabel,
      isStorageAvailable: available,
      hasCachedStatus: hasCache,
      status: status,
    );
  }
}

class _GoogleDriveTrialRepository extends _CachedTrialRepository {
  static const String _storageLabel = 'Google Drive appDataFolder';

  @override
  Future<bool> isAvailableForTrial() async {
    final session = await GoogleAccountHelper.trialDriveSession();
    return session != null;
  }

  @override
  Future<TrialStatus?> loadStatus() async {
    final cached = await loadCachedStatus();
    try {
      final session = await GoogleAccountHelper.trialDriveSession();
      if (session == null) return cached;
      final fileId = await _findFileId(session.api);
      if (fileId == null) return cached;

      final response = await session.api.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;
      final bytes = await response.stream.expand((chunk) => chunk).toList();
      final raw = utf8.decode(bytes);
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return cached;
      final status = TrialStatus.fromJson(decoded);
      if (status == null) return cached;

      final refreshed = status.refreshed(DateTime.now().toUtc());
      if (refreshed.lastSeenAtUtc != status.lastSeenAtUtc) {
        await _upsert(session.api, refreshed, fileId: fileId);
      }
      await cacheStatus(refreshed);
      return refreshed;
    } catch (_) {
      return cached;
    }
  }

  @override
  Future<TrialStartResult> startTrial() async {
    try {
      final session =
          await GoogleAccountHelper.trialDriveSession(interactive: true);
      if (session == null) {
        return const TrialStartResult(outcome: TrialStartOutcome.cancelled);
      }

      final existing = await loadStatus();
      if (existing != null) {
        return TrialStartResult(
          outcome: existing.isActive
              ? TrialStartOutcome.activeExisting
              : TrialStartOutcome.expiredExisting,
          status: existing,
        );
      }

      final started = TrialStatus.start(
        nowUtc: DateTime.now().toUtc(),
        accountKey: session.accountKey,
        source: TrialSource.googleDriveAppData,
      );
      await _upsert(session.api, started);
      await cacheStatus(started);
      return TrialStartResult(
        outcome: TrialStartOutcome.started,
        status: started,
      );
    } catch (_) {
      return const TrialStartResult(outcome: TrialStartOutcome.failed);
    }
  }

  @override
  Future<bool> clearStatus() async {
    await clearCachedStatus();
    try {
      final session =
          await GoogleAccountHelper.trialDriveSession(interactive: true);
      if (session == null) return false;
      final fileId = await _findFileId(session.api);
      if (fileId == null) return true;
      await session.api.files.delete(fileId, supportsAllDrives: false);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> expireStatus() async {
    try {
      final session =
          await GoogleAccountHelper.trialDriveSession(interactive: true);
      if (session == null) return false;
      final fileId = await _findFileId(session.api);
      if (fileId == null) return false;
      final status = await loadStatus();
      if (status == null) return false;
      final now = DateTime.now().toUtc();
      final expired = status.copyWith(
        expiresAtUtc: now.subtract(const Duration(seconds: 1)),
        lastSeenAtUtc: now,
      );
      await _upsert(session.api, expired, fileId: fileId);
      await cacheStatus(expired);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<TrialDebugState> debugState() async {
    final hasCache = await hasCachedStatus();
    final status = await loadStatus();
    final available = await isAvailableForTrial();
    return TrialDebugState(
      storageLabel: _storageLabel,
      isStorageAvailable: available,
      hasCachedStatus: hasCache,
      status: status,
    );
  }

  Future<String?> _findFileId(drive.DriveApi api) async {
    final list = await api.files.list(
      q: "name='${TrialStatus.fileName}' and trashed=false",
      spaces: 'appDataFolder',
      $fields: 'files(id)',
    );
    if (list.files == null || list.files!.isEmpty) return null;
    return list.files!.first.id;
  }

  Future<void> _upsert(
    drive.DriveApi api,
    TrialStatus status, {
    String? fileId,
  }) async {
    final payload = utf8.encode(jsonEncode(status.toJson()));
    final media = drive.Media(
      Stream.value(payload),
      payload.length,
      contentType: 'application/json',
    );
    final id = fileId ?? await _findFileId(api);
    if (id != null) {
      await api.files.update(
        drive.File(),
        id,
        uploadMedia: media,
      );
      return;
    }

    await api.files.create(
      drive.File()
        ..name = TrialStatus.fileName
        ..parents = ['appDataFolder'],
      uploadMedia: media,
    );
  }
}
