import 'package:mycookcoach/features/shop/domain/entities/order_entity.dart';

abstract class OrderRepository {

  Future<void> createOrder(OrderEntity order);
  Future<List<OrderEntity>> loadAllOrders(String userId);
}
