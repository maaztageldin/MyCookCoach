import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/location_espace/data/repositories/location_repository_impl.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/booking_entity.dart';

class FetchBookingsByKitchenIdUseCase {
  final LocationRepositoryImpl repository;

  FetchBookingsByKitchenIdUseCase(this.repository);

  Future<Either<Failure, List<BookingEntity>>> call(String kitchenId) async {
    return await repository.fetchBookingsByKitchenId(kitchenId);
  }
}