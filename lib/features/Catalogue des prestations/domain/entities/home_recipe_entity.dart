import 'package:equatable/equatable.dart';

class HomeRecipeEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final String category;
  final String duration;
  final String serving;
  final String chef;
  final String date;
  final String chefId;
  final String description;

  const HomeRecipeEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.duration,
    required this.serving,
    required this.chef,
    required this.date,
    required this.chefId,
    required this.description,
  });

  HomeRecipeEntity copyWith({
    String? id,
    String? name,
    String? image,
    String? category,
    String? duration,
    String? serving,
    String? chef,
    String? date,
    String? chefId,
    String? description,
  }) {
    return HomeRecipeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      serving: serving ?? this.serving,
      chef: chef ?? this.chef,
      date: date ?? this.date,
      chefId: chefId ?? this.chefId,
      description: description ?? this.description,
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'category': category,
      'duration': duration,
      'serving': serving,
      'chef': chef,
      'date': date,
      'chef_id': chefId,
      'description': description,
    };
  }

  static HomeRecipeEntity fromDocument(Map<String, dynamic> doc) {
    return HomeRecipeEntity(
      id: doc['id'],
      name: doc['name'],
      image: doc['image'],
      category: doc['category'],
      duration: doc['duration'],
      serving: doc['serving'],
      chef: doc['chef'],
      date: doc['date'],
      chefId: doc['chef_id'],
      description: doc['description'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    category,
    duration,
    serving,
    chef,
    date,
    chefId,
    description,
  ];
}
