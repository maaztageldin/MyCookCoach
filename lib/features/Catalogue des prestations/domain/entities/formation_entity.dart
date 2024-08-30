import 'package:cloud_firestore/cloud_firestore.dart';

class FormationEntity {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String price;
  final String duration;
  final String formateurId;
  final DateTime startDate;
  final DateTime endDate;

  FormationEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.duration,
    required this.formateurId,
    required this.startDate,
    required this.endDate,
  });

  factory FormationEntity.fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return FormationEntity(
      id: doc['id'],
      title: doc['title'],
      description: doc['description'],
      imageUrl: doc['imageUrl'],
      price: doc['price'],
      duration: doc['duration'],
      formateurId: doc['formateurId'],
      startDate: (doc['startDate'] as Timestamp).toDate(),
      endDate: (doc['endDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'duration': duration,
      'formateurId': formateurId,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
