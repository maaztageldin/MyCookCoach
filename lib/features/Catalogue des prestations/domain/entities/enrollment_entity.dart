import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentEntity {
  final String id;
  final String userId;
  final String formationId;
  final DateTime enrollmentDate;

  EnrollmentEntity({
    required this.id,
    required this.userId,
    required this.formationId,
    required this.enrollmentDate,
  });

  factory EnrollmentEntity.fromDocument(Map<String, dynamic> doc) {
    return EnrollmentEntity(
      id: doc['id'],
      userId: doc['userId'],
      formationId: doc['formationId'],
      enrollmentDate: (doc['enrollmentDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'userId': userId,
      'formationId': formationId,
      'enrollmentDate': enrollmentDate,
    };
  }
}
