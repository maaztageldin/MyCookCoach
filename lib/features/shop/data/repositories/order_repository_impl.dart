import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mycookcoach/features/shop/domain/entities/order_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> createOrder(OrderEntity order) async {
    List<Map<String, dynamic>> products = order.products.entries.map((entry) {
      return {
        'productId': entry.key,
        'quantity': entry.value,
      };
    }).toList();

    await firestore.collection('orders').add({
      'userId': order.userId,
      'products': products,
      'orderNumber': order.orderNumber,
      'totalPrice': order.totalPrice,
      'orderDate': order.orderDate,
      'status': order.status,
      'fullName': order.fullName,
      'shippingAddress': order.shippingAddress,
      'city': order.city,
      'postalCode': order.postalCode,
    });
  }

    @override
    Future<List<OrderEntity>> loadAllOrders(String userId) async {
      try {
        final querySnapshot = await firestore
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .get();

        return querySnapshot.docs
            .map((doc) => OrderEntity.fromDocument(doc.data()))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('Failed to load orders: $e');
        }
        throw Exception('Failed to load orders: $e');
      }
    }
  }
