import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'database_helper.dart';

/// Generates a single combined CSV file from the SQLite DB and invokes the
/// system share sheet so the user can save or send the file.
class ExportHelper {
  ExportHelper._();

  // ─────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────

  /// Builds avoid_export.csv (habits + relapses + monthly summary in one
  /// file with section headers), then opens the share sheet.
  /// Returns `true` on success, `false` on error.
  static Future<bool> exportAllData() async {
    try {
      final dir = await getTemporaryDirectory();
      final file = await _buildCombinedCsv(dir);

      await Share.shareXFiles(
        [file],
        subject: 'Avoid — My Progress Export',
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Combined CSV
  // ─────────────────────────────────────────────────────────────

  static Future<XFile> _buildCombinedCsv(Directory dir) async {
    final db = await DatabaseHelper.instance.database;
    final rows = <List<dynamic>>[];

    // ── HABITS section ──────────────────────────────────────────
    rows.add(['--- HABITS ---']);
    rows.add([
      'ID', 'Habit', 'Type', 'Recurring', 'Est. Cost', 'Cost Type',
      'Priority', 'Archived', 'Created At', 'Updated At',
      'Last Relapse At', 'Relapse Count',
    ]);

    final habits = await db.rawQuery('''
      SELECT
        id, todoText, avoidType, isRecurring, estimatedCost, costType,
        priority, isArchived, createdAt, updatedAt, lastRelapsedAt, relapseCount
      FROM todo
      ORDER BY createdAt ASC
    ''');

    for (final r in habits) {
      rows.add([
        r['id'],
        r['todoText'],
        r['avoidType'],
        _boolStr(r['isRecurring']),
        r['estimatedCost'],
        r['costType'],
        r['priority'],
        _boolStr(r['isArchived']),
        r['createdAt'],
        r['updatedAt'],
        r['lastRelapsedAt'] ?? '',
        r['relapseCount'],
      ]);
    }

    // ── RELAPSES section ────────────────────────────────────────
    rows.add([]);
    rows.add(['--- RELAPSES ---']);
    rows.add(['ID', 'Habit', 'Relapsed At', 'Trigger Note', 'Cause Tag']);

    final relapses = await db.rawQuery('''
      SELECT r.id, t.todoText AS habit, r.relapsedAt, r.triggerNote, r.causeTag
      FROM relapse_logs r
      LEFT JOIN todo t ON r.todoId = t.id
      ORDER BY r.relapsedAt DESC
    ''');

    for (final r in relapses) {
      rows.add([
        r['id'],
        r['habit'] ?? '',
        r['relapsedAt'],
        r['triggerNote'] ?? '',
        r['causeTag'] ?? '',
      ]);
    }

    // ── MONTHLY SUMMARY section ─────────────────────────────────
    rows.add([]);
    rows.add(['--- MONTHLY SUMMARY ---']);
    rows.add(['Month', 'Avoidances', 'Relapses']);

    final monthly = await DatabaseHelper.instance.getMonthlyStats();
    final monthlyRelapses = await db.rawQuery('''
      SELECT strftime('%Y-%m', relapsedAt) AS month, COUNT(*) AS count
      FROM relapse_logs
      GROUP BY month
      ORDER BY month ASC
    ''');

    final relapseMap = {
      for (final r in monthlyRelapses)
        r['month'] as String: r['count'] as int,
    };

    for (final m in monthly) {
      final month = m['month'] as String;
      rows.add([month, m['count'], relapseMap[month] ?? 0]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    final file = File('${dir.path}/avoid_export.csv');
    await file.writeAsString(csv);
    return XFile(file.path, mimeType: 'application/octet-stream', name: 'avoid_export.csv');
  }

  // ─────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────

  static String _boolStr(dynamic val) {
    if (val == null) return '';
    return (val == 1 || val == true) ? 'Yes' : 'No';
  }
}
