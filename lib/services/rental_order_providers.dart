import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/rental_order.dart';
import 'rental_order_repository.dart';

final rentalOrderRepositoryProvider = Provider<RentalOrderRepository>((ref) => RentalOrderRepository());

final rentalOrdersProvider = FutureProvider.family<List<RentalOrder>, String>((ref, email) async {
  return ref.read(rentalOrderRepositoryProvider).getOrdersForUser(email);
});