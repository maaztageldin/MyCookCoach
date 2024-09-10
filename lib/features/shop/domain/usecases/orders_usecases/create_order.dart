import 'package:mycookcoach/features/shop/domain/entities/order_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/order_repository.dart';

class CreateOrderUesCase {
  final OrderRepository repository;

  CreateOrderUesCase(this.repository);

  Future<void> call(OrderEntity order) {
    return repository.createOrder(order);
  }
}
