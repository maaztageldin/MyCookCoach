class LocalEntity {
  final String id;
  final String imageUrl;
  final String name;
  final String address;
  final List<String> kitchens;

  LocalEntity({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.kitchens,
  });

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'address': address,
      'kitchenIds': kitchens,
    };
  }

  static LocalEntity fromDocument(Map<String, dynamic> doc) {
    return LocalEntity(
      id: doc['id'],
      imageUrl: doc['image_url'],
      name: doc['name'],
      address: doc['address'],
      kitchens: List<String>.from(doc['kitchens']),
    );
  }
}
