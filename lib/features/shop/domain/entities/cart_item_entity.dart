import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';

class CartItemEntity {
  final String id;
  final String userId;
  final String name;
  final String category;
  final String description;
  final String price;
  final String imageUrl;
  final int quantity;
  final int stockQuantity;

  CartItemEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.stockQuantity,
  });

  factory CartItemEntity.fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return CartItemEntity(
      id: doc['id'],
      userId: doc['userId'],
      name: doc['name'],
      category: doc['category'],
      description: doc['description'],
      price: doc['price'],
      imageUrl: doc['imageUrl'],
      quantity: doc['quantity'],
      stockQuantity: doc['stockQuantity'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'stockQuantity': stockQuantity,
    };
  }

  factory CartItemEntity.fromKitchenItem(KitchenItemEntity item, int quantity, String userId) {
    return CartItemEntity(
      id: item.id,
      userId: userId,
      name: item.name,
      category: item.category,
      description: item.description,
      price: item.price,
      imageUrl: item.imageUrl,
      quantity: quantity,
      stockQuantity: item.stockQuantity,
    );
  }

  CartItemEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? category,
    String? description,
    String? price,
    String? imageUrl,
    int? quantity,
    int? stockQuantity,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }
}
