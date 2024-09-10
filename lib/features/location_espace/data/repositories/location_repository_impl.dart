import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/kitchen_entity.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/local_entity.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/booking_entity.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:either_dart/either.dart';
import 'package:mycookcoach/features/location_espace/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, List<LocalEntity>>> fetchAllLocals() async {
    try {
      final snapshot = await _firestore.collection('locals').get();
      final locals = snapshot.docs.map((doc) => LocalEntity.fromDocument(doc.data())).toList();
      return Right(locals);
    } catch (e) {
      return Left(FireBaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  Future<Either<Failure, List<KitchenEntity>>> fetchKitchensByLocalId(String localId) async {
    try {
      final snapshot = await _firestore
          .collection('kitchens')
          .where('localId', isEqualTo: localId)
          .get();
      final kitchens = snapshot.docs.map((doc) => KitchenEntity.fromDocument(doc.data())).toList();
      return Right(kitchens);
    } catch (e) {
      return Left(FireBaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  Future<Either<Failure, void>> bookKitchen(BookingEntity booking) async {
    try {
      await _firestore.collection('bookings').add(booking.toDocument());
      return const Right(null);
    } catch (e) {
      return Left(FireBaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  Future<Either<Failure, List<BookingEntity>>> fetchBookingsByKitchenId(String kitchenId) async {
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('kitchenId', isEqualTo: kitchenId)
          .get();
      final bookings = snapshot.docs.map((doc) => BookingEntity.fromDocument(doc.data())).toList();
      return Right(bookings);
    } catch (e) {
      return Left(FireBaseFailure(message: e.toString(), statusCode: 500));
    }
  }
}
