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
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Menambah kolom baru jika ada perubahan versi database di masa depan
          await db.execute('''ALTER TABLE tasks ADD COLUMN newColumn TEXT''');
        }
      },
    );
  }

  // Fungsi untuk menyisipkan data
  Future<int> insert(Map<String, dynamic> row) async {
    try {
      final db = await database;
      return await db.insert('tasks', row);
    } catch (e) {
      print('Error inserting row: $e');
      return 0; // Mengembalikan 0 jika terjadi error
    }
  }

  // Fungsi untuk membaca semua data, dengan pengurutan berdasarkan deadline
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await database;
    return await db.query(
      'tasks',
      orderBy: 'deadline ASC', // Urutkan berdasarkan deadline
    );
  }

  // Fungsi untuk memperbarui data
  Future<int> update(Map<String, dynamic> row) async {
    try {
      final db = await database;
      return await db.update(
        'tasks',
        row,
        where: 'id = ?',
        whereArgs: [row['id']],
      );
    } catch (e) {
      print('Error updating row: $e');
      return 0; // Mengembalikan 0 jika terjadi error
    }
  }

  // Fungsi untuk menghapus data berdasarkan ID
  Future<int> delete(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting row: $e');
      return 0; // Mengembalikan 0 jika terjadi error
    }
  }

  // Fungsi untuk menghapus data berdasarkan kategori
  Future<int> deleteByCategory(String category) async {
    try {
      final db = await database;
      return await db.delete(
        'tasks',
        where: 'category = ?',
        whereArgs: [category],
      );
    } catch (e) {
      print('Error deleting by category: $e');
      return 0; // Mengembalikan 0 jika terjadi error
    }
  }
}
