import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/todo.dart';
import '../model/tag.dart';
import '../model/relapse_log.dart';
import '../model/goal.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  /// Closes the current connection and clears the cache so the next call to
  /// [database] opens a fresh connection. Call this before replacing the DB
  /// file (e.g. during a backup restore).
  static Future<void> closeAndReset() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 12,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Schema creation
  // ─────────────────────────────────────────────────────────────

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE todo (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      todoText TEXT NOT NULL,
      priority INTEGER NOT NULL DEFAULT 1,
      orderIndex INTEGER NOT NULL DEFAULT 0,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      isArchived INTEGER NOT NULL DEFAULT 0,
      archivedAt TEXT,
      isRecurring INTEGER NOT NULL DEFAULT 1,
      eventDate TEXT,
      lastRelapsedAt TEXT,
      relapseCount INTEGER NOT NULL DEFAULT 0,
      estimatedCost REAL,
      costType INTEGER NOT NULL DEFAULT 0,
      avoidType INTEGER NOT NULL DEFAULT 0,
      contactId TEXT,
      locationName TEXT,
      latitude REAL,
      longitude REAL,
      reminderDateTime TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE relapse_logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      todoId TEXT NOT NULL,
      relapsedAt TEXT NOT NULL,
      triggerNote TEXT,
      causeTag TEXT,
      FOREIGN KEY (todoId) REFERENCES todo (id) ON DELETE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE milestone_reflections (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      todoId TEXT NOT NULL,
      milestoneDays INTEGER NOT NULL,
      chipTag TEXT,
      note TEXT,
      createdAt TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE tags (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      color INTEGER NOT NULL,
      isBuiltIn INTEGER NOT NULL DEFAULT 0
    )
    ''');

    await db.execute('''
    CREATE TABLE todo_tags (
      todoId TEXT NOT NULL,
      tagId TEXT NOT NULL,
      PRIMARY KEY (todoId, tagId)
    )
    ''');

    await db.execute('''
    CREATE TABLE xp_events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      source TEXT NOT NULL,
      amount INTEGER NOT NULL,
      earnedAt TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE goals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      todoId TEXT,
      todoText TEXT,
      targetValue REAL NOT NULL,
      isActive INTEGER NOT NULL DEFAULT 1,
      isPreset INTEGER NOT NULL DEFAULT 0,
      completedAt TEXT,
      createdAt TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE badges (
      id TEXT PRIMARY KEY,
      unlockedAt TEXT NOT NULL,
      notifiedAt TEXT
    )
    ''');

    await _seedBuiltInTags(db);
  }

  Future _seedBuiltInTags(Database db) async {
    for (final tag in Tag.builtIns) {
      await db.insert('tags', tag.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    // Cleanup: Remove the 'other' tag if it was previously seeded
    await db.delete('tags', where: 'id = ?', whereArgs: ['other']);
    await db.delete('todo_tags', where: 'tagId = ?', whereArgs: ['other']);
  }

  // ─────────────────────────────────────────────────────────────
  // Migrations
  // ─────────────────────────────────────────────────────────────

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE todo ADD COLUMN category INTEGER NOT NULL DEFAULT 3');
      await db.execute(
          'ALTER TABLE todo ADD COLUMN priority INTEGER NOT NULL DEFAULT 1');
      await db.execute(
          'ALTER TABLE todo ADD COLUMN orderIndex INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE todo ADD COLUMN createdAt TEXT');
      await db.execute('ALTER TABLE todo ADD COLUMN updatedAt TEXT');
      await db.execute(
          'ALTER TABLE todo ADD COLUMN isArchived INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE todo ADD COLUMN archivedAt TEXT');

      final now = DateTime.now().toIso8601String();
      await db.execute(
          'UPDATE todo SET createdAt = ?, updatedAt = ? WHERE createdAt IS NULL',
          [now, now]);
    }

    if (oldVersion < 3) {
      await db.execute(
          'ALTER TABLE todo ADD COLUMN isRecurring INTEGER NOT NULL DEFAULT 1');
      await db.execute('ALTER TABLE todo ADD COLUMN eventDate TEXT');
      await db.execute('ALTER TABLE todo ADD COLUMN lastRelapsedAt TEXT');
      await db.execute(
          'ALTER TABLE todo ADD COLUMN relapseCount INTEGER NOT NULL DEFAULT 0');
      await db.execute(
          'UPDATE todo SET lastRelapsedAt = createdAt WHERE lastRelapsedAt IS NULL');
    }

    if (oldVersion < 4) {
      await db.execute('''
      CREATE TABLE relapse_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        todoId TEXT NOT NULL,
        relapsedAt TEXT NOT NULL,
        triggerNote TEXT,
        FOREIGN KEY (todoId) REFERENCES todo (id) ON DELETE CASCADE
      )
      ''');
    }

    if (oldVersion < 5) {
      await db.execute('ALTER TABLE todo ADD COLUMN estimatedCost REAL');
    }

    if (oldVersion < 6) {
      // Create tags table
      await db.execute('''
      CREATE TABLE IF NOT EXISTS tags (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        isBuiltIn INTEGER NOT NULL DEFAULT 0
      )
      ''');

      // Create junction table
      await db.execute('''
      CREATE TABLE IF NOT EXISTS todo_tags (
        todoId TEXT NOT NULL,
        tagId TEXT NOT NULL,
        PRIMARY KEY (todoId, tagId)
      )
      ''');

      // Seed built-in tags
      await _seedBuiltInTags(db);

      // Migrate existing category values to the corresponding built-in tags
      // category column: 0=health, 1=productivity, 2=social, 3=other
      final categoryToTagId = ['health', 'productivity', 'social', 'other'];
      final todos = await db.query('todo', columns: ['id', 'category']);
      for (final row in todos) {
        final todoId = row['id'].toString();
        final catIdx = (row['category'] as int?) ?? 3;
        final tagId = categoryToTagId[catIdx.clamp(0, 3)];
        await db.insert(
          'todo_tags',
          {'todoId': todoId, 'tagId': tagId},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }

    if (oldVersion < 7) {
      await db.execute(
          'ALTER TABLE todo ADD COLUMN avoidType INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE todo ADD COLUMN contactId TEXT');
      await db.execute('ALTER TABLE todo ADD COLUMN locationName TEXT');
      await db.execute('ALTER TABLE todo ADD COLUMN latitude REAL');
      await db.execute('ALTER TABLE todo ADD COLUMN longitude REAL');
      await db.execute('ALTER TABLE todo ADD COLUMN reminderDateTime TEXT');
    }
    if (oldVersion < 8) {
      await db.execute(
          'ALTER TABLE todo ADD COLUMN costType INTEGER NOT NULL DEFAULT 0');
    }
    if (oldVersion < 9) {
      await db.delete('tags', where: 'id = ?', whereArgs: ['other']);
      await db.delete('todo_tags', where: 'tagId = ?', whereArgs: ['other']);
    }
    if (oldVersion < 10) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS xp_events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source TEXT NOT NULL,
        amount INTEGER NOT NULL,
        earnedAt TEXT NOT NULL
      )
      ''');
    }
    if (oldVersion < 11) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        todoId TEXT,
        todoText TEXT,
        targetValue REAL NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1,
        isPreset INTEGER NOT NULL DEFAULT 0,
        completedAt TEXT,
        createdAt TEXT NOT NULL
      )
      ''');
    }
    if (oldVersion < 12) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS badges (
        id TEXT PRIMARY KEY,
        unlockedAt TEXT NOT NULL,
        notifiedAt TEXT
      )
      ''');
      // Phase 1A: cause tag on relapse logs + milestone reflections table
      try {
        await db.execute(
            'ALTER TABLE relapse_logs ADD COLUMN causeTag TEXT');
      } catch (_) {
        // Column may already exist on fresh installs
      }
      await db.execute('''
      CREATE TABLE IF NOT EXISTS milestone_reflections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        todoId TEXT NOT NULL,
        milestoneDays INTEGER NOT NULL,
        chipTag TEXT,
        note TEXT,
        createdAt TEXT NOT NULL
      )
      ''');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Tag CRUD
  // ─────────────────────────────────────────────────────────────

  Future<List<Tag>> getAllTags() async {
    final db = await instance.database;
    final result = await db.query('tags', orderBy: 'isBuiltIn DESC, name ASC');
    return result.map((e) => Tag.fromMap(e)).toList();
  }

  Future<String> createTag(Tag tag) async {
    final db = await instance.database;
    await db.insert('tags', tag.toMap());
    return tag.id;
  }

  Future<void> deleteTag(String tagId) async {
    final db = await instance.database;
    await db.delete('todo_tags', where: 'tagId = ?', whereArgs: [tagId]);
    await db.delete('tags', where: 'id = ?', whereArgs: [tagId]);
  }

  Future<List<String>> getTagIdsForTodo(String todoId) async {
    final db = await instance.database;
    final result = await db.query(
      'todo_tags',
      columns: ['tagId'],
      where: 'todoId = ?',
      whereArgs: [todoId],
    );
    return result.map((e) => e['tagId'] as String).toList();
  }

  Future<void> setTagsForTodo(String todoId, List<String> tagIds) async {
    final db = await instance.database;
    await db.delete('todo_tags', where: 'todoId = ?', whereArgs: [todoId]);
    for (final tagId in tagIds) {
      await db.insert(
        'todo_tags',
        {'todoId': todoId, 'tagId': tagId},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // ToDo CRUD
  // ─────────────────────────────────────────────────────────────

  Future<String> create(ToDo todo) async {
    final db = await instance.database;
    final id = await db.insert('todo', todo.toMap());
    if (todo.tagIds.isNotEmpty) {
      await setTagsForTodo(id.toString(), todo.tagIds);
    }
    return id.toString();
  }

  Future<List<ToDo>> readAllTodos({bool includeArchived = false}) async {
    final db = await instance.database;
    final whereClause = includeArchived ? null : 'isArchived = 0';
    final result = await db.query(
      'todo',
      where: whereClause,
      orderBy: 'orderIndex ASC, createdAt DESC',
    );

    final todos = <ToDo>[];
    for (final row in result) {
      final id = row['id'].toString();
      final tagIds = await getTagIdsForTodo(id);
      todos.add(ToDo.fromMap(row, tagIds: tagIds));
    }
    return todos;
  }

  Future<List<ToDo>> readArchivedTodos() async {
    final db = await instance.database;
    final result = await db.query(
      'todo',
      where: 'isArchived = 1',
      orderBy: 'archivedAt DESC',
    );

    final todos = <ToDo>[];
    for (final row in result) {
      final id = row['id'].toString();
      final tagIds = await getTagIdsForTodo(id);
      todos.add(ToDo.fromMap(row, tagIds: tagIds));
    }
    return todos;
  }

  Future<int> update(ToDo todo) async {
    final db = await instance.database;
    final updatedTodo = todo.copyWith(updatedAt: DateTime.now());
    final result = await db.update(
      'todo',
      updatedTodo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
    if (todo.id != null) {
      await setTagsForTodo(todo.id!, todo.tagIds);
    }
    return result;
  }

  Future<int> archiveTodo(int id) async {
    final db = await instance.database;
    return db.update(
      'todo',
      {
        'isArchived': 1,
        'archivedAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> restoreTodo(int id) async {
    final db = await instance.database;
    return db.update(
      'todo',
      {
        'isArchived': 0,
        'archivedAt': null,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    await db
        .delete('todo_tags', where: 'todoId = ?', whereArgs: [id.toString()]);
    return await db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────────────────────────────────────────────
  // Relapse logs
  // ─────────────────────────────────────────────────────────────

  Future<int> addRelapseLog(RelapseLog log) async {
    final db = await instance.database;
    return await db.insert('relapse_logs', log.toMap());
  }

  Future<List<RelapseLog>> getRelapseLogs(String todoId) async {
    final db = await instance.database;
    final result = await db.query(
      'relapse_logs',
      where: 'todoId = ?',
      whereArgs: [todoId],
      orderBy: 'relapsedAt DESC',
    );
    return result.map((json) => RelapseLog.fromMap(json)).toList();
  }

  Future<List<Map<String, dynamic>>> getAllRelapseLogsRaw() async {
    final db = await instance.database;
    return await db.query('relapse_logs', orderBy: 'relapsedAt DESC');
  }

  // ─────────────────────────────────────────────────────────────
  // Statistics queries
  // ─────────────────────────────────────────────────────────────

  Future<int> getTotalAvoidedCount() async {
    final db = await instance.database;
    final result = await db
        .rawQuery('SELECT COUNT(*) as count FROM todo WHERE isArchived = 1');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getActiveCount() async {
    final db = await instance.database;
    final result = await db
        .rawQuery('SELECT COUNT(*) as count FROM todo WHERE isArchived = 0');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<String, int>> getTagBreakdown() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT t.id, t.name, COUNT(tt.todoId) as count
      FROM tags t
      LEFT JOIN todo_tags tt ON t.id = tt.tagId
      LEFT JOIN todo td ON tt.todoId = td.id AND td.isArchived = 1
      GROUP BY t.id, t.name
      HAVING count > 0
    ''');
    final Map<String, int> breakdown = {};
    for (final row in result) {
      breakdown[row['name'] as String] = row['count'] as int;
    }
    return breakdown;
  }

  Future<Map<TodoPriority, int>> getPriorityBreakdown() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT priority, COUNT(*) as count 
      FROM todo 
      WHERE isArchived = 0 
      GROUP BY priority
    ''');

    final Map<TodoPriority, int> breakdown = {};
    for (final row in result) {
      final priority = TodoPriority.values[row['priority'] as int];
      breakdown[priority] = row['count'] as int;
    }
    return breakdown;
  }

  Future<List<Map<String, dynamic>>> getMostAvoidedItems(
      {int limit = 5}) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT todoText, COUNT(*) as avoidCount 
      FROM todo 
      WHERE isArchived = 1 
      GROUP BY todoText 
      ORDER BY avoidCount DESC 
      LIMIT ?
    ''', [limit]);

    return result;
  }

  /// Returns a map of date-string → avoidance-count for a given month.
  /// Used by the calendar heatmap in statistics_screen.
  Future<Map<String, int>> getDailyAvoidanceMap(int year, int month) async {
    final db = await instance.database;
    final yearStr = year.toString();
    final monthStr = month.toString().padLeft(2, '0');
    final result = await db.rawQuery('''
      SELECT strftime('%Y-%m-%d', archivedAt) as day, COUNT(*) as count
      FROM todo
      WHERE isArchived = 1
        AND archivedAt IS NOT NULL
        AND strftime('%Y', archivedAt) = ?
        AND strftime('%m', archivedAt) = ?
      GROUP BY day
    ''', [yearStr, monthStr]);

    final Map<String, int> map = {};
    for (final row in result) {
      map[row['day'] as String] = row['count'] as int;
    }
    return map;
  }

  /// Returns monthly avoidance counts for the last 12 months.
  Future<List<Map<String, dynamic>>> getMonthlyStats() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT strftime('%Y-%m', archivedAt) as month, COUNT(*) as count
      FROM todo
      WHERE isArchived = 1
        AND archivedAt IS NOT NULL
        AND archivedAt >= date('now', '-12 months')
      GROUP BY month
      ORDER BY month ASC
    ''');
    return result;
  }

  /// Returns a map of DateTime.weekday → relapse count for ALL time.
  /// Weekday format matches Dart: 1 = Monday … 7 = Sunday.
  /// Used by smart pattern notifications.
  Future<Map<int, int>> getRelapseDayPattern() async {
    final db = await instance.database;
    // strftime('%w') returns 0=Sunday, 1=Monday, ..., 6=Saturday
    final result = await db.rawQuery('''
      SELECT CAST(strftime('%w', relapsedAt) AS INTEGER) as dow,
             COUNT(*) as count
      FROM relapse_logs
      GROUP BY dow
    ''');
    // Initialise all weekdays to 0
    final Map<int, int> map = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
    for (final row in result) {
      final dow = (row['dow'] as int? ?? 0);
      final count = row['count'] as int? ?? 0;
      // Convert strftime %w (0=Sun) → DateTime.weekday (1=Mon, 7=Sun)
      final weekday = dow == 0 ? 7 : dow;
      map[weekday] = count;
    }
    return map;
  }

  Future<List<Map<String, dynamic>>> getWeeklyStats() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT
        strftime('%Y-%W', archivedAt) as week,
        COUNT(*) as count
      FROM todo
      WHERE isArchived = 1 AND archivedAt IS NOT NULL
      GROUP BY week
      ORDER BY week DESC
      LIMIT 8
    ''');

    return result.reversed.toList();
  }

  /// Returns avoidance counts for the last 7 days (today − 6 days to today),
  /// always returning exactly 7 entries with 0 for days with no activity.
  Future<List<Map<String, dynamic>>> getLast7DaysStats() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT date(archivedAt) as day, COUNT(*) as count
      FROM todo
      WHERE isArchived = 1
        AND archivedAt IS NOT NULL
        AND date(archivedAt) >= date('now', '-6 days')
      GROUP BY day
      ORDER BY day ASC
    ''');

    final map = <String, int>{};
    for (final row in result) {
      map[row['day'] as String] = row['count'] as int;
    }

    final now = DateTime.now();
    final days = <Map<String, dynamic>>[];
    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final dateStr =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      days.add({'date': dateStr, 'weekday': day.weekday, 'count': map[dateStr] ?? 0});
    }
    return days;
  }

  Future<int> getThisWeekArchivedCount() async {
    final db = await instance.database;
    final cutoff = DateTime.now()
        .subtract(const Duration(days: 7))
        .toIso8601String();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as c FROM todo WHERE isArchived = 1 AND archivedAt >= ?',
      [cutoff],
    );
    return (result.first['c'] as int?) ?? 0;
  }

  Future<int> updateOrderIndex(int id, int newIndex) async {
    final db = await instance.database;
    return db.update(
      'todo',
      {'orderIndex': newIndex, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Goals
  // ─────────────────────────────────────────────────────────────

  Future<int> createGoal(Goal goal) async {
    final db = await instance.database;
    return await db.insert('goals', goal.toMap());
  }

  /// Returns all currently active goals, newest first.
  Future<List<Goal>> getActiveGoals() async {
    final db = await instance.database;
    final result = await db.query(
      'goals',
      where: 'isActive = 1',
      orderBy: 'createdAt DESC',
    );
    return result.map(Goal.fromMap).toList();
  }

  /// Marks a goal as completed (still active so it stays visible until dismissed).
  Future<void> completeGoal(int id) async {
    final db = await instance.database;
    await db.update(
      'goals',
      {
        'completedAt': DateTime.now().toIso8601String(),
        'isActive': 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Permanently removes a goal (user dismissed it).
  Future<void> deleteGoal(int id) async {
    final db = await instance.database;
    await db.delete('goals', where: 'id = ?', whereArgs: [id]);
  }

  /// True if there is already an active preset goal in the DB.
  Future<bool> hasActivePresetGoal() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as c FROM goals WHERE isActive = 1 AND isPreset = 1');
    return ((result.first['c'] as int?) ?? 0) > 0;
  }

  /// Sum of money saved (costType = 0) from habits archived this calendar month.
  Future<double> getThisMonthMoneySavings() async {
    final db = await instance.database;
    final now = DateTime.now();
    final monthStart =
        DateTime(now.year, now.month, 1).toIso8601String();
    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(estimatedCost), 0) as total
      FROM todo
      WHERE isArchived = 1
        AND archivedAt >= ?
        AND costType = 0
        AND estimatedCost IS NOT NULL
    ''', [monthStart]);
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // ─────────────────────────────────────────────────────────────
  // XP events
  // ─────────────────────────────────────────────────────────────

  /// Persists an XP award event.
  Future<void> awardXp(String source, int amount) async {
    final db = await instance.database;
    await db.insert('xp_events', {
      'source': source,
      'amount': amount,
      'earnedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Returns the sum of all awarded XP.
  Future<int> getTotalXp() async {
    final db = await instance.database;
    final result =
        await db.rawQuery('SELECT COALESCE(SUM(amount), 0) as total FROM xp_events');
    return (result.first['total'] as num?)?.toInt() ?? 0;
  }

  /// Returns true if an event with exactly [source] has already been recorded.
  /// Used to guard once-per-todo milestone awards (e.g. "streak_7d:42").
  Future<bool> hasXpSourceKey(String source) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as c FROM xp_events WHERE source = ?', [source]);
    return ((result.first['c'] as int?) ?? 0) > 0;
  }

  // ─────────────────────────────────────────────────────────────
  // Milestone reflections (Phase 1A — Plus feature)
  // ─────────────────────────────────────────────────────────────

  Future<void> addMilestoneReflection({
    required String todoId,
    required int milestoneDays,
    String? chipTag,
    String? note,
  }) async {
    final db = await instance.database;
    await db.insert('milestone_reflections', {
      'todoId': todoId,
      'milestoneDays': milestoneDays,
      'chipTag': chipTag,
      'note': note,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getMilestoneReflections(
      String todoId) async {
    final db = await instance.database;
    return await db.query(
      'milestone_reflections',
      where: 'todoId = ?',
      whereArgs: [todoId],
      orderBy: 'createdAt DESC',
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Badges
  // ─────────────────────────────────────────────────────────────

  /// Persists a badge unlock. No-op if already unlocked (IGNORE conflict).
  Future<void> unlockBadge(String id) async {
    final db = await instance.database;
    await db.insert(
      'badges',
      {
        'id': id,
        'unlockedAt': DateTime.now().toIso8601String(),
        'notifiedAt': null,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Returns all unlocked badges ordered by unlock time (oldest first).
  Future<List<Map<String, dynamic>>> getUnlockedBadges() async {
    final db = await instance.database;
    return await db.query('badges', orderBy: 'unlockedAt ASC');
  }

  /// Total number of relapse log entries across all habits (for Honest badge).
  Future<int> getTotalRelapseCount() async {
    final db = await instance.database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM relapse_logs');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Earliest createdAt date across all habits (for Veteran badge).
  Future<DateTime?> getFirstHabitCreatedAt() async {
    final db = await instance.database;
    final result =
        await db.rawQuery('SELECT MIN(createdAt) as first FROM todo');
    final str = result.first['first'] as String?;
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
