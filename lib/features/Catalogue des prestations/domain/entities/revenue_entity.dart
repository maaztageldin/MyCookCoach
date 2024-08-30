class RevenueEntity {
  final String id;
  final String formationId;
  final double totalRevenue;
  final double myCookCoachFee;
  final double netRevenue;

  RevenueEntity({
    required this.id,
    required this.formationId,
    required this.totalRevenue,
    required this.myCookCoachFee,
    required this.netRevenue,
  });

  factory RevenueEntity.fromDocument(Map<String, dynamic> doc) {
    return RevenueEntity(
      id: doc['id'],
      formationId: doc['formationId'],
      totalRevenue: doc['totalRevenue'],
      myCookCoachFee: doc['myCookCoachFee'],
      netRevenue: doc['netRevenue'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'formationId': formationId,
      'totalRevenue': totalRevenue,
      'myCookCoachFee': myCookCoachFee,
      'netRevenue': netRevenue,
    };
  }
}
