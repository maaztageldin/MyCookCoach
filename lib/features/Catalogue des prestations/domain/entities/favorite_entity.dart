import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  final String id;
  final String userId;
  final String recipeId;
  final String type;

  const FavoriteEntity({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.type,
  });

  FavoriteEntity copyWith({
    String? id,
    String? userId,
    String? recipeId,
    String? type,
  }) {
    return FavoriteEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recipeId: recipeId ?? this.recipeId,
      type: type ?? this.type,
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'userId': userId,
      'recipeId': recipeId,
      'type': type,
    };
  }

  static FavoriteEntity fromDocument(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FavoriteEntity(
      id: data['id'],
      userId: data['userId'],
      recipeId: data['recipeId'],
      type: data['type'],
    );
  }


  @override
  List<Object?> get props => [
    id,
    userId,
    recipeId,
    type,
  ];
}
