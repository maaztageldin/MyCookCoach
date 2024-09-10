import 'package:cloud_firestore/cloud_firestore.dart';

class OrderEntity {
  final String userId;
  final int orderNumber;
  final Map<String, int> products;
  final int totalPrice;
  final DateTime orderDate;
  final String status;
  final String fullName;
  final String shippingAddress;
  final String city;
  final String postalCode;

  OrderEntity({
    required this.userId,
    required this.orderNumber,
    required this.products,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
    required this.fullName,
    required this.shippingAddress,
    required this.city,
    required this.postalCode,
  });

  factory OrderEntity.fromDocument(Map<String, dynamic> doc) {

    Map<String, int> productsMap = {};
    if (doc['products'] is List) {
      for (var product in doc['products']) {
        if (product is Map<String, dynamic>) {
          String productId = product['productId'];
          int quantity = product['quantity'];
          productsMap[productId] = quantity;
        }
      }
    }

    return OrderEntity(
      userId: doc['userId'] ?? '',
      orderNumber: doc['orderNumber'] ?? 0,
      products: productsMap,
      totalPrice: doc['totalPrice'] ?? 0,
      orderDate: (doc['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: doc['status'] ?? 'unknown',
      fullName: doc['fullName'] ?? '',
      shippingAddress: doc['shippingAddress'] ?? '',
      city: doc['city'] ?? '',
      postalCode: doc['postalCode'] ?? '',
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      'orderNumber': orderNumber,
      'products': products,
      'totalPrice': totalPrice,
      'orderDate': orderDate,
      'status': status,
      'fullName': fullName,
      'shippingAddress': shippingAddress,
      'city': city,
      'postalCode': postalCode,
    };
  }
}
