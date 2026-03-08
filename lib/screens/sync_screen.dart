import 'dart:io';
import 'package:flutter/material.dart';
import '../helpers/sync_helper.dart';
import '../main.dart';

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
  DateTime? _lastSync;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _loadLastSync();
  }

  Future<void> _loadLastSync() async {
    final t = await SyncHelper.lastSyncTime();
    if (mounted) setState(() => _lastSync = t);
  }

  Future<void> _uploadNow() async {
    setState(() {
      _isUploading = true;
      _statusMessage = null;
    });
    // force: true bypasses the 10-minute throttle for manual backups
    final success = await SyncHelper.uploadIfNeeded(force: true);
    final t = await SyncHelper.lastSyncTime();
    if (mounted) {
      setState(() {
        _isUploading = false;
        _lastSync = t;
        _statusMessage = success
            ? '✓ Backup uploaded successfully.'
            : 'Upload failed. Check your connection and try again.';
      });
    }
  }

  Future<void> _checkForBackup() async {
    setState(() {
      _isChecking = true;
      _statusMessage = null;
    });

    final backup = await SyncHelper.downloadLatestBackup();
    if (!mounted) return;
    setState(() => _isChecking = false);

    if (backup == null) {
      setState(() {
        _statusMessage =
            'No backup found in the cloud yet. Tap "Back up now" to create one.';
      });
      return;
    }

    // Backup found — always ask user whether to restore
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Backup found'),
        content: const Text(
          '⚠️ This will overwrite your current data with the cloud backup.\n\n'
          'Any changes made since your last backup will be lost. '
          'Are you sure you want to restore?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await SyncHelper.restoreFromBackup(backup);
      if (mounted) {
        // Soft-restart the entire widget tree so the DB connection
        // and all providers reload from the restored database
        RestartWidget.restartApp(context);
      }
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;
    final cloudName = isIos ? 'iCloud' : 'Google Drive';
    final cloudIcon = isIos ? Icons.cloud_outlined : Icons.add_to_drive_outlined;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Sync'),
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
                      Icon(cloudIcon, size: 28,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        '$cloudName Backup',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _lastSync == null
                      ? Text(
                          'Never synced yet.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Last synced:',
                                style: TextStyle(fontWeight: FontWeight.w500)),
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
            onPressed: _isUploading ? null : _uploadNow,
            icon: _isUploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.cloud_upload_outlined),
            label: Text(_isUploading ? 'Uploading…' : 'Back up now'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _isChecking ? null : _checkForBackup,
            icon: _isChecking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_download_outlined),
            label: Text(_isChecking ? 'Checking…' : 'Check for backup'),
          ),
          const SizedBox(height: 24),

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
                  const Text(
                    'How it works',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '• Your data is backed up to your own $cloudName — '
                    'Avoid never sees it.\n'
                    '• Backups happen automatically (at most every 10 minutes) '
                    'after major actions.\n'
                    '• To restore on a new device: install Avoid, sign in, '
                    'then tap "Check for backup".',
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
              'Cloud sync is not available on this platform.',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ],
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
