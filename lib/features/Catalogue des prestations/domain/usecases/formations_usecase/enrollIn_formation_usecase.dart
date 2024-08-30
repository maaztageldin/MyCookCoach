import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/formation_repository.dart';

class EnrollInFormationUseCase {
  final FormationRepository repository;

  EnrollInFormationUseCase({required this.repository});

  Future<void> call(String userId, String formationId) async {
    return await repository.enrollInFormation(userId, formationId);
  }
}
