import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/formation_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/formation_repository.dart';

class GetFormationsUseCase {
  final FormationRepository repository;

  GetFormationsUseCase({required this.repository});

  Future<List<FormationEntity>> call() async {
    return await repository.getFormations();
  }
}
