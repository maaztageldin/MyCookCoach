import 'package:equatable/equatable.dart';

abstract class PurchaseEvent extends Equatable {
  const PurchaseEvent();

  @override
  List<Object> get props => [];
}

class PaymentConfirmed extends PurchaseEvent {
  final String userId;
  final int orderNumber;
  final Map<String, int> products;
  final int totalPrice;
  final String fullName;
  final String shippingAddress;
  final String city;
  final String postalCode;

  const PaymentConfirmed({
    required this.userId,
    required this.orderNumber,
    required this.products,
    required this.totalPrice,
    required this.fullName,
    required this.shippingAddress,
    required this.city,
    required this.postalCode,
  });

  @override
  List<Object> get props => [
    userId,
    orderNumber,
    products,
    totalPrice,
    fullName,
    shippingAddress,
    city,
    postalCode,
  ];
}

class LoadOrders extends PurchaseEvent {
  final String userId;

  LoadOrders(this.userId);
}
