import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/booking_entity.dart';

abstract class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAllLocalsEvent extends LocationEvent {}

class FetchKitchensByLocalIdEvent extends LocationEvent {
  final String localId;

  FetchKitchensByLocalIdEvent(this.localId);

  @override
  List<Object?> get props => [localId];
}

class BookKitchenEvent extends LocationEvent {
  final BookingEntity booking;

  BookKitchenEvent(this.booking);

  @override
  List<Object?> get props => [booking];
}

class FetchBookingsByKitchenIdEvent extends LocationEvent {
  final String kitchenId;

  FetchBookingsByKitchenIdEvent(this.kitchenId);

  @override
  List<Object?> get props => [kitchenId];
}
