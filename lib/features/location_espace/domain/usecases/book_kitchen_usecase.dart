import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/location_espace/data/repositories/location_repository_impl.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/booking_entity.dart';

class BookKitchenUseCase {
  final LocationRepositoryImpl repository;

  BookKitchenUseCase(this.repository);

  Future<Either<Failure, void>> call(BookingEntity booking) async {
    return await repository.bookKitchen(booking);
  }
}