import 'package:mycookcoach/features/location_espace/domain/entities/kitchen_entity.dart';

class LocalEntity {
  final String id;
  final String name;
  final String address;
  final List<String> kitchens;

  LocalEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.kitchens,
  });

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'kitchenIds': kitchens,
    };
  }

  static LocalEntity fromDocument(Map<String, dynamic> doc) {
    return LocalEntity(
      id: doc['id'],
      name: doc['name'],
      address: doc['address'],
      kitchens: List<String>.from(doc['kitchens']),
    );
  }
}
