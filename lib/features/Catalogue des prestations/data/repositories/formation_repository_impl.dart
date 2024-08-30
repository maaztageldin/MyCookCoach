import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/enrollment_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/formation_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/formation_repository.dart';

class FormationRepositoryImpl implements FormationRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<FormationEntity>> getFormations() async {
    final snapshot = await firestore.collection('formations').get();
    return snapshot.docs
        .map((doc) => FormationEntity.fromDocument(doc))
        .toList();
  }

  @override
  Future<void> enrollInFormation(String userId, String formationId) async {
    final enrollment = EnrollmentEntity(
      id: firestore.collection('enrollments').doc().id,
      userId: userId,
      formationId: formationId,
      enrollmentDate: DateTime.now(),
    );
    await firestore
        .collection('enrollments')
        .doc(enrollment.id)
        .set(enrollment.toDocument());
  }
}
