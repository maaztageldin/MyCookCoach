import 'package:mycookcoach/features/shop/domain/entities/order_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/order_repository.dart';

class LoadOrdersUesCase {
  final OrderRepository repository;

  LoadOrdersUesCase({required this.repository});

  Future<List<OrderEntity>> call(String userId) async {
    return await repository.loadAllOrders(userId);
  }
}
