import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkIfEnrolled(String userId, String formationId) async {
    final enrollment = await _firestore
        .collection('enrollments')
        .where('userId', isEqualTo: userId)
        .where('formationId', isEqualTo: formationId)
        .get();

    return enrollment.docs.isNotEmpty;
  }
}
