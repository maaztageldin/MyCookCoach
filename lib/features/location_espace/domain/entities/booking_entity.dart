class BookingEntity {
  final String id;
  final String kitchenId;
  final String userId;
  final String localId;
  final DateTime startDate;
  final DateTime endDate;
  final int price;

  BookingEntity({
    required this.id,
    required this.kitchenId,
    required this.userId,
    required this.localId,
    required this.startDate,
    required this.endDate,
    required this.price,
  });

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'kitchenId': kitchenId,
      'userId': userId,
      'localId': localId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'price': price,
    };
  }

  static BookingEntity fromDocument(Map<String, dynamic> doc) {
    return BookingEntity(
      id: doc['id'],
      kitchenId: doc['kitchenId'],
      userId: doc['userId'],
      localId: doc['localId'],
      startDate: DateTime.parse(doc['startDate']),
      endDate: DateTime.parse(doc['endDate']),
      price: doc['price']
    );
  }
}
