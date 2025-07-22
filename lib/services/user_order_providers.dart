import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rental_order_repository.dart';

final userOrdersRepositoryProvider = Provider<RentalOrderRepository>((ref) => RentalOrderRepository());

final userOrdersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, email) async {
  return ref.read(userOrdersRepositoryProvider).getUserOrdersDetailed(email);
});