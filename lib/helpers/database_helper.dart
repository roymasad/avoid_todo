import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/todo.dart';
import '../model/tag.dart';
import '../model/relapse_log.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 10,
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
      FOREIGN KEY (todoId) REFERENCES todo (id) ON DELETE CASCADE
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

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
