import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/formation_entity.dart';

abstract class FormationRepository {
  Future<List<FormationEntity>> getFormations();
  Future<void> enrollInFormation(String userId, String formationId);
}
