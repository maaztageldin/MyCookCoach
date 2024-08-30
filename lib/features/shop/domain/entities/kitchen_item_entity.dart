
import 'package:cloud_firestore/cloud_firestore.dart';

class KitchenItemEntity {
  final String id;
  final String name;
  final String category;
  final String description;
  final String price;
  final String imageUrl;
  final int stockQuantity;
  final String rating;

  KitchenItemEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stockQuantity,
    this.rating = "0.0",
  });

  factory KitchenItemEntity.fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return KitchenItemEntity(
      id: doc['id'],
      name: doc['name'],
      category: doc['category'],
      description: doc['description'],
      price: doc['price'],
      imageUrl: doc['imageUrl'],
      stockQuantity: doc['stockQuantity'],
      rating: doc['rating'] ?? "0.0",
    );
  }


  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stockQuantity': stockQuantity,
      'rating': rating,
    };
  }
}
