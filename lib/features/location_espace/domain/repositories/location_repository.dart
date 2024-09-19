import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/booking_entity.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/kitchen_location_entity.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/local_entity.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<LocalEntity>>> fetchAllLocals();
  Future<Either<Failure, List<KitchenLocationEntity>>> fetchKitchensByLocalId(String localId);
  Future<Either<Failure, void>> bookKitchen(BookingEntity booking);
  Future<Either<Failure, List<BookingEntity>>> fetchBookingsByKitchenId(String kitchenId);
}







