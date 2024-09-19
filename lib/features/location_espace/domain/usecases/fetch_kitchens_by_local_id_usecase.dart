import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/location_espace/data/repositories/location_repository_impl.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/kitchen_location_entity.dart';

class FetchKitchensByLocalIdUseCase {
  final LocationRepositoryImpl repository;

  FetchKitchensByLocalIdUseCase(this.repository);

  Future<Either<Failure, List<KitchenLocationEntity>>> call(String localId) async {
    return await repository.fetchKitchensByLocalId(localId);
  }
}