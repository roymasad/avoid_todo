import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/todo.dart';

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
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const textNullableType = 'TEXT';

    await db.execute('''
    CREATE TABLE todo (
      id $idType,
      todoText $textType,
      category $intType DEFAULT 3,
      priority $intType DEFAULT 1,
      orderIndex $intType DEFAULT 0,
      createdAt $textType,
      updatedAt $textType,
      isArchived $intType DEFAULT 0,
      archivedAt $textNullableType
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration from v1 to v2: Add new columns
      await db.execute('ALTER TABLE todo ADD COLUMN category INTEGER NOT NULL DEFAULT 3');
      await db.execute('ALTER TABLE todo ADD COLUMN priority INTEGER NOT NULL DEFAULT 1');
      await db.execute('ALTER TABLE todo ADD COLUMN orderIndex INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE todo ADD COLUMN createdAt TEXT');
      await db.execute('ALTER TABLE todo ADD COLUMN updatedAt TEXT');
      await db.execute('ALTER TABLE todo ADD COLUMN isArchived INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE todo ADD COLUMN archivedAt TEXT');
      
      // Set default dates for existing records
      final now = DateTime.now().toIso8601String();
      await db.execute('UPDATE todo SET createdAt = ?, updatedAt = ? WHERE createdAt IS NULL', [now, now]);
    }
  }

  Future<int> create(ToDo todo) async {
    final db = await instance.database;
    return await db.insert('todo', todo.toMap());
  }

  Future<List<ToDo>> readAllTodos({bool includeArchived = false}) async {
    final db = await instance.database;

    final whereClause = includeArchived ? null : 'isArchived = 0';
    final result = await db.query(
      'todo',
      where: whereClause,
      orderBy: 'orderIndex ASC, createdAt DESC',
    );

    return result.map((json) => ToDo.fromMap(json)).toList();
  }

  Future<List<ToDo>> readArchivedTodos() async {
    final db = await instance.database;

    final result = await db.query(
      'todo',
      where: 'isArchived = 1',
      orderBy: 'archivedAt DESC',
    );

    return result.map((json) => ToDo.fromMap(json)).toList();
  }

  Future<List<ToDo>> readTodosByCategory(TodoCategory category) async {
    final db = await instance.database;

    final result = await db.query(
      'todo',
      where: 'category = ? AND isArchived = 0',
      whereArgs: [category.index],
      orderBy: 'orderIndex ASC',
    );

    return result.map((json) => ToDo.fromMap(json)).toList();
  }

  Future<int> update(ToDo todo) async {
    final db = await instance.database;
    final updatedTodo = todo.copyWith(updatedAt: DateTime.now());

    return db.update(
      'todo',
      updatedTodo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
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

    return await db.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Statistics Queries
  Future<int> getTotalAvoidedCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM todo WHERE isArchived = 1');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getActiveCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM todo WHERE isArchived = 0');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<TodoCategory, int>> getCategoryBreakdown() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT category, COUNT(*) as count 
      FROM todo 
      WHERE isArchived = 1 
      GROUP BY category
    ''');

    final Map<TodoCategory, int> breakdown = {};
    for (final row in result) {
      final category = TodoCategory.values[row['category'] as int];
      breakdown[category] = row['count'] as int;
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

  Future<List<Map<String, dynamic>>> getMostAvoidedItems({int limit = 5}) async {
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

  Future<int> updateOrderIndex(int id, int newIndex) async {
    final db = await instance.database;

    return db.update(
      'todo',
      {'orderIndex': newIndex, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
