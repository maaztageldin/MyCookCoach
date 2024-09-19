import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/booking_entity.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/kitchen_location_entity.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/local_entity.dart';
import 'package:mycookcoach/features/location_espace/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<LocalEntity>>> fetchAllLocals() async {
    try {
      final snapshot = await _firestore.collection('locals').get();
      final locals = snapshot.docs
          .map((doc) => LocalEntity.fromDocument(doc.data()))
          .toList();
      return Right(locals);
    } catch (e) {
      return Left(FireBaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, List<KitchenLocationEntity>>> fetchKitchensByLocalId(
      String localId) async {
    try {
      final snapshot = await _firestore
          .collection('kitchens')
          .where('localId', isEqualTo: localId)
          .get();
      final kitchens = snapshot.docs
          .map((doc) => KitchenLocationEntity.fromDocument(doc.data()))
          .toList();
      return Right(kitchens);
    } catch (e) {
      return Left(FireBaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, void>> bookKitchen(BookingEntity booking) async {
    try {
      DocumentReference documentRef =
          await _firestore.collection('bookings').add(booking.toDocument());

      String bookingId = documentRef.id;
      await documentRef.update({'id': bookingId});

      return const Right(null);
    } catch (e) {
      return Left(FireBaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> fetchBookingsByKitchenId(
      String kitchenId) async {
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('kitchenId', isEqualTo: kitchenId)
          .get();
      final bookings = snapshot.docs
          .map((doc) => BookingEntity.fromDocument(doc.data()))
          .toList();
      return Right(bookings);
    } catch (e) {
      return Left(FireBaseFailure(message: e.toString(), statusCode: 500));
    }
  }
}
