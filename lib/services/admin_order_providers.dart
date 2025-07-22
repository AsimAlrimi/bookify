import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rental_order_repository.dart';

final adminOrdersRepositoryProvider = Provider<RentalOrderRepository>((ref) => RentalOrderRepository());

final adminOrdersProvider = StateNotifierProvider<AdminOrdersNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final repo = ref.watch(adminOrdersRepositoryProvider);
  return AdminOrdersNotifier(repo)..load();
});

class AdminOrdersNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final RentalOrderRepository _repo;
  AdminOrdersNotifier(this._repo) : super(const AsyncValue.loading());

  Future<void> load() async {
    try {
      final data = await _repo.getAllOrdersDetailed();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateStatus(int orderId, String status) async {
    try {
      await _repo.updateStatus(orderId, status);
      await load();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}