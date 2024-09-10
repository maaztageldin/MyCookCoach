import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/location_espace/data/repositories/location_repository_impl.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/local_entity.dart';

class FetchAllLocalsUseCase {
  final LocationRepositoryImpl repository;

  FetchAllLocalsUseCase(this.repository);

  Future<Either<Failure, List<LocalEntity>>> call() async {
    return await repository.fetchAllLocals();
  }
}