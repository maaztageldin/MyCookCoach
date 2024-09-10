class KitchenEntity {
  final String id;
  final String name;
  final bool isAvailable;
  final String localId;
  final String priceH;
  final List<DateTime> availability;

  KitchenEntity({
    required this.id,
    required this.name,
    required this.isAvailable,
    required this.localId,
    required this.priceH,
    required this.availability,
  });

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'name': name,
      'isAvailable': isAvailable,
      'localId': localId,
      'priceH': priceH,
      'availability': availability.map((date) => date.toIso8601String()).toList(),
    };
  }

  static KitchenEntity fromDocument(Map<String, dynamic> doc) {
    return KitchenEntity(
      id: doc['id'],
      name: doc['name'],
      isAvailable: doc['isAvailable'],
      localId: doc['localId'],
      priceH: doc['priceH'],
      availability: (doc['availability'] as List<dynamic>).map((date) => DateTime.parse(date)).toList(),
    );
  }
}
