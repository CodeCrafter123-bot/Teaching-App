import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 2, // bumped to 2 so exam_results table is created
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');

    // Courses table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS courses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        modules INTEGER
      )
    ''');

    // User Progress table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userEmail TEXT,
        courseId INTEGER,
        completedModules INTEGER DEFAULT 0,
        FOREIGN KEY(courseId) REFERENCES courses(id)
      )
    ''');

    // Exam Results table ✅
    await db.execute('''
      CREATE TABLE IF NOT EXISTS exam_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        course TEXT,
        score INTEGER,
        total INTEGER,
        percentage REAL,
        date TEXT
      )
    ''');

    // Pre-insert courses
    await db.insert("courses", {"name": "Algorithms", "modules": 12});
    await db.insert("courses", {"name": "Data Structures", "modules": 10});
    await db.insert("courses", {"name": "Operating Systems", "modules": 8});
    await db.insert("courses", {"name": "Computer Networks", "modules": 7});
    await db.insert("courses", {"name": "Databases", "modules": 6});
  }

  // 🔹 Make sure table is created if DB was old
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS exam_results (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          course TEXT,
          score INTEGER,
          total INTEGER,
          percentage REAL,
          date TEXT
        )
      ''');
    }
  }

  // User Registration
  Future<int> registerUser(String name, String email, String password) async {
    final db = await database;
    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  // Login
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  // Update user progress
  Future<void> updateUserProgress(
      String email, int courseId, int completed) async {
    final db = await database;

    final result = await db.query(
      'user_progress',
      where: 'userEmail = ? AND courseId = ?',
      whereArgs: [email, courseId],
    );

    if (result.isEmpty) {
      await db.insert('user_progress', {
        'userEmail': email,
        'courseId': courseId,
        'completedModules': completed,
      });
    } else {
      await db.update(
        'user_progress',
        {'completedModules': completed},
        where: 'userEmail = ? AND courseId = ?',
        whereArgs: [email, courseId],
      );
    }
  }

  // Get progress
  Future<List<Map<String, dynamic>>> getUserProgress(String email) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT c.id, c.name, c.modules, 
             IFNULL(up.completedModules, 0) as completedModules
      FROM courses c
      LEFT JOIN user_progress up
        ON c.id = up.courseId AND up.userEmail = ?
    ''', [email]);

    return result;
  }

  // Update user info
  Future<int> updateUser(String email, {String? newName, String? newPassword}) async {
    final db = await database;
    Map<String, dynamic> values = {};
    if (newName != null) values['name'] = newName;
    if (newPassword != null) values['password'] = newPassword;
    return await db.update(
      'users',
      values,
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // ✅ Save exam result
  Future<int> insertExamResult(String course, int score, int total) async {
    final db = await database;
    final percentage = (score / total) * 100;

    return await db.insert(
      "exam_results",
      {
        "course": course,
        "score": score,
        "total": total,
        "percentage": percentage,
        "date": DateTime.now().toIso8601String(),
      },
    );
  }

  // ✅ Fetch all exam results
  Future<List<Map<String, dynamic>>> getExamResults() async {
    final db = await database;
    return await db.query("exam_results", orderBy: "date DESC");
  }
}
