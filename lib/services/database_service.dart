import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  static Database? _database;

  DatabaseService._();
  factory DatabaseService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'bookify.db'),
      version: 2, // Increment version for migration
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books(
            id INTEGER PRIMARY KEY,
            title TEXT,
            author TEXT,
            rating REAL,
            description TEXT,
            available INTEGER,
            imagePath TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE rental_orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bookId INTEGER,
            userEmail TEXT,
            startDate TEXT,
            endDate TEXT,
            status TEXT,
            FOREIGN KEY(bookId) REFERENCES books(id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE books ADD COLUMN imagePath TEXT');
        }
      },
    );
    return _database!;
  }
}
