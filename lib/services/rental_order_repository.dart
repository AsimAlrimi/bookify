import 'database_service.dart';
import 'models/rental_order.dart';

class RentalOrderRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<int> insertOrder(RentalOrder order) async {
    final db = await _dbService.database;
    return await db.insert('rental_orders', order.toMap());
  }

  Future<List<RentalOrder>> getOrdersForUser(String userEmail) async {
    final db = await _dbService.database;
    final maps = await db.query('rental_orders', where: 'userEmail = ?', whereArgs: [userEmail]);
    return List.generate(maps.length, (i) => RentalOrder.fromMap(maps[i]));
  }

  Future<List<RentalOrder>> getAllOrders() async {
    final db = await _dbService.database;
    final maps = await db.query('rental_orders', orderBy: 'id DESC');
    return List.generate(maps.length, (i) => RentalOrder.fromMap(maps[i]));
  }

  /// Detailed orders with book info (title, author)
  Future<List<Map<String, dynamic>>> getAllOrdersDetailed() async {
    final db = await _dbService.database;
    return await db.rawQuery('''
      SELECT ro.id, ro.bookId, ro.userEmail, ro.startDate, ro.endDate, ro.status, b.title as bookTitle, b.author as bookAuthor
      FROM rental_orders ro
      INNER JOIN books b ON ro.bookId = b.id
      ORDER BY ro.id DESC
    ''');
  }

  Future<int> updateStatus(int orderId, String status) async {
    final db = await _dbService.database;
    return await db.update(
      'rental_orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  Future<List<Map<String, dynamic>>> getUserOrdersDetailed(String email) async {
  final db = await _dbService.database;
  return await db.rawQuery('''
    SELECT ro.id, ro.bookId, ro.userEmail, ro.startDate, ro.endDate, ro.status, b.title as bookTitle, b.author as bookAuthor
    FROM rental_orders ro
    INNER JOIN books b ON ro.bookId = b.id
    WHERE ro.userEmail = ?
    ORDER BY ro.id DESC
  ''', [email]);
  }
  
}