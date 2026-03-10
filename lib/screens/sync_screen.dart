import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/app_analytics.dart';
import '../helpers/sync_helper.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../providers/purchase_provider.dart';
import '../widgets/tracked_screen.dart';

/// Shows cloud sync status and lets the user trigger a manual sync or restore.
///
/// Available only for Plus subscribers.  Accessed from the settings drawer.
class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  bool _isUploading = false;
  bool _isChecking = false;
  bool _isDeleting = false;
  bool _hasRemoteBackup = false;
  DateTime? _lastSync;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final t = await SyncHelper.lastSyncTime();
    final hasBackup = await SyncHelper.hasRemoteBackup();
    if (mounted) {
      setState(() {
        _lastSync = t;
        _hasRemoteBackup = hasBackup;
      });
    }
  }

  Future<void> _uploadNow() async {
    await AppAnalytics.instance.trackEvent(
      'sync_backup_now',
      parameters: const {'source_screen': 'sync_screen'},
    );
    setState(() {
      _isUploading = true;
      _statusMessage = null;
    });
    // force: true bypasses the 10-minute throttle for manual backups
    final success = await SyncHelper.uploadIfNeeded(force: true);
    final t = await SyncHelper.lastSyncTime();
    if (mounted) {
      final l10n = AppLocalizations.of(context);
      setState(() {
        _isUploading = false;
        _lastSync = t;
        _hasRemoteBackup = success || _hasRemoteBackup;
        _statusMessage = success
            ? (l10n?.syncUploadSuccess ?? '✓ Backup uploaded successfully.')
            : (l10n?.syncUploadFailed ??
                'Upload failed. Check your connection and try again.');
      });
    }
  }

  Future<void> _checkForBackup() async {
    await AppAnalytics.instance.trackEvent(
      'sync_restore_checked',
      parameters: const {'source_screen': 'sync_screen'},
    );
    setState(() {
      _isChecking = true;
      _statusMessage = null;
    });

    final backup = await SyncHelper.downloadLatestBackup();
    if (!mounted) return;
    setState(() => _isChecking = false);

    if (backup == null) {
      final l10n = AppLocalizations.of(context);
      setState(() {
        _hasRemoteBackup = false;
        _statusMessage = l10n?.syncNoBackupFound ??
            'No backup found in the cloud yet. Tap the button below to create one.';
      });
      return;
    }

    setState(() => _hasRemoteBackup = true);

    // Backup found — always ask user whether to restore
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n?.syncBackupFoundTitle ?? 'Backup found'),
        content: Text(
          l10n?.syncRestoreWarning ??
              '⚠️ This will overwrite your current data with the cloud backup.\n\n'
                  'Any changes made since your last backup will be lost. '
                  'Are you sure you want to restore?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n?.restore ?? 'Restore'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await AppAnalytics.instance.trackEvent(
        'sync_restore_confirmed',
        parameters: const {'source_screen': 'sync_screen'},
      );
      await SyncHelper.restoreFromBackup(backup);
      if (mounted) {
        // Soft-restart the entire widget tree so the DB connection
        // and all providers reload from the restored database
        RestartWidget.restartApp(context);
      }
    }
  }

  Future<void> _deleteBackup() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete cloud backup?'),
        content: const Text(
          'This removes the saved backup from your cloud account. Your current local data will stay on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    await AppAnalytics.instance.trackEvent(
      'sync_delete_backup_confirmed',
      parameters: const {'source_screen': 'sync_screen'},
    );

    setState(() {
      _isDeleting = true;
      _statusMessage = null;
    });

    final success = await SyncHelper.deleteRemoteBackup();
    if (!mounted) return;
    setState(() {
      _isDeleting = false;
      if (success) {
        _hasRemoteBackup = false;
        _lastSync = null;
      }
      _statusMessage = success
          ? 'Cloud backup deleted.'
          : 'Could not delete the cloud backup. Check your connection and try again.';
    });
  }

  // ─────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final purchase = context.watch<PurchaseProvider>();
    final hasPurchasedPlus = purchase.hasPurchasedPlus;
    final hasTrial = purchase.hasActiveTrial;
    final isIos = Platform.isIOS;
    final cloudName = isIos ? 'iCloud' : 'Google Drive';
    final cloudIcon =
        isIos ? Icons.cloud_outlined : Icons.add_to_drive_outlined;

    return TrackedScreen(
      screenName: 'sync_screen',
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n?.cloudSync ?? 'Cloud Sync'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Status card ──────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(cloudIcon,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          l10n?.syncCloudBackupTitle(cloudName) ??
                              '$cloudName Backup',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _lastSync == null
                        ? Text(
                            l10n?.syncNeverSynced ?? 'Never synced yet.',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n?.syncLastSynced ?? 'Last synced:',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 2),
                              Text(
                                _formatDateTime(_lastSync!),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                    if (_statusMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _statusMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Actions ──────────────────────────────────────────────
            FilledButton.icon(
              onPressed:
                  (!hasPurchasedPlus || _isUploading) ? null : _uploadNow,
              icon: _isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.cloud_upload_outlined),
              label: Text(_isUploading
                  ? (l10n?.syncUploading ?? 'Uploading…')
                  : (l10n?.syncBackupNow ?? 'Back up now')),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed:
                  (!hasPurchasedPlus || _isChecking) ? null : _checkForBackup,
              icon: _isChecking
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download_outlined),
              label: Text(_isChecking
                  ? (l10n?.syncChecking ?? 'Checking…')
                  : (l10n?.syncCheckForBackup ?? 'Check and Restore')),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: (!hasPurchasedPlus || !_hasRemoteBackup || _isDeleting)
                  ? null
                  : _deleteBackup,
              icon: _isDeleting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline),
              label: Text(
                _isDeleting ? 'Deleting…' : 'Delete cloud backup',
              ),
            ),
            const SizedBox(height: 24),
            if (!hasPurchasedPlus)
              Card(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.55),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    hasTrial
                        ? 'Cloud backup and restore unlock after you purchase Plus. Trials include the rest of Plus, but sync stays disabled.'
                        : 'Cloud backup and restore are available after purchasing Plus.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            if (!hasPurchasedPlus) const SizedBox(height: 24),

            // ── Info ─────────────────────────────────────────────────
            Card(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.4),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.syncHowItWorksTitle ?? 'How it works',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n?.syncHowItWorksBody(cloudName) ??
                          '• Your data is backed up to your own $cloudName — Avoid never sees it.\n'
                              '• Backups happen automatically (at most every 10 minutes) after major actions.\n'
                              '• To restore on a new device: install Avoid, sign in, then tap "Check and Restore".\n'
                              '• On Android, backups are stored in Avoid\'s private Google Drive app data and can be deleted from this screen.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!SyncHelper.isSupported) ...[
              const SizedBox(height: 16),
              Text(
                l10n?.syncNotAvailable ??
                    'Cloud sync is not available on this platform.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.toLocal();
    final date = '${d.day}/${d.month}/${d.year}';
    final time =
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return '$date at $time';
  }
}
