

import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/booking_entity.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/kitchen_entity.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/local_entity.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);

  @override
  List<Object?> get props => [message];
}

class LocalsLoaded extends LocationState {
  final List<LocalEntity> locals;

  LocalsLoaded(this.locals);

  @override
  List<Object?> get props => [locals];
}

class KitchensLoaded extends LocationState {
  final List<KitchenEntity> kitchens;

  KitchensLoaded(this.kitchens);

  @override
  List<Object?> get props => [kitchens];
}

class KitchenBooked extends LocationState {}

class BookingsLoaded extends LocationState {
  final List<BookingEntity> bookings;

  BookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}
