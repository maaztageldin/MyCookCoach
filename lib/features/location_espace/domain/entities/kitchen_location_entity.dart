class KitchenLocationEntity {
  final String id;
  final String name;
  bool isAvailable;
  final String localId;
  final String priceH;
  final String details;
  List<Map<String, dynamic>> availabilityPeriods;
  final List<String> images;

  KitchenLocationEntity({
    required this.id,
    required this.name,
    required this.isAvailable,
    required this.localId,
    required this.priceH,
    required this.details,
    required this.availabilityPeriods,
    required this.images,
  });

  bool isPeriodAvailable(DateTime startDate, DateTime endDate) {
    for (var period in availabilityPeriods) {
      final existingStart = period['start_date'] as DateTime;
      final existingEnd = period['end_date'] as DateTime;
      if (_overlaps(existingStart, existingEnd, startDate, endDate)) {
        return false;
      }
    }
    return true;
  }

  void updateAvailability(DateTime startDate, DateTime endDate) {
    availabilityPeriods.removeWhere((period) {
      final existingStart = period['start_date'] as DateTime;
      final existingEnd = period['end_date'] as DateTime;
      return _overlaps(existingStart, existingEnd, startDate, endDate);
    });
    if (availabilityPeriods.isEmpty) {
      isAvailable = false;
    }
  }

  bool _overlaps(DateTime existingStart, DateTime existingEnd, DateTime startDate, DateTime endDate) {
    return startDate.isBefore(existingEnd) && endDate.isAfter(existingStart);
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'name': name,
      'isAvailable': isAvailable,
      'localId': localId,
      'priceH': priceH,
      'details': details,
      'availabilityPeriods': availabilityPeriods.map((period) {
        return {
          'start_date': (period['start_date'] as DateTime).toIso8601String(),
          'end_date': (period['end_date'] as DateTime).toIso8601String(),
          'price': period['price'],
        };
      }).toList(),
      'images': images,
    };
  }

  static KitchenLocationEntity fromDocument(Map<String, dynamic> doc) {
    return KitchenLocationEntity(
      id: doc['id'] ?? '',
      name: doc['name'] ?? '',
      isAvailable: doc['isAvailable'] ?? false,
      localId: doc['localId'] ?? '',
      priceH: doc['priceH'] ?? '',
      details: doc['details'] ?? '',
      availabilityPeriods: (doc['availabilityPeriods'] as List<dynamic>).map((period) {
        final startDate = DateTime.parse(period['start_date']);
        final endDate = DateTime.parse(period['end_date']);
        final price = period['price'] as int;
        return {
          'start_date': startDate,
          'end_date': endDate,
          'price': price,
        };
      }).toList(),
      images: List<String>.from(doc['images'] ?? []),
    );
  }
}
