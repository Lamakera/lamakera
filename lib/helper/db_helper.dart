import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            todoText TEXT NOT NULL,
            deadline TEXT NOT NULL,
            category TEXT NOT NULL,
            notification INTEGER NOT NULL DEFAULT 0,
            isDone INTEGER NOT NULL DEFAULT 0
          );
        ''');
      },
    );
  }

  // Fungsi untuk menyisipkan data
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('tasks', row);
  }

  // Fungsi untuk membaca semua data
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await database;
    return await db.query('tasks');
  }

  // Fungsi untuk memperbarui data
  Future<int> update(Map<String, dynamic> row) async {
    final db = await database;
    return await db.update(
      'tasks',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  // Fungsi untuk menghapus data
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
