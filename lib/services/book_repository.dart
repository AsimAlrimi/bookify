import 'database_service.dart';
import 'models/book.dart';

class BookRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<int> insertBook(Book book) async {
    final db = await _dbService.database;
    return await db.insert('books', book.toMap());
  }

  Future<List<Book>> getAllBooks() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<int> updateBook(Book book) async {
    final db = await _dbService.database;
    return await db.update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  Future<int> deleteBook(int id) async {
    final db = await _dbService.database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}