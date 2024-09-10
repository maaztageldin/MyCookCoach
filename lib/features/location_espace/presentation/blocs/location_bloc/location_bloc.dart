import 'package:bloc/bloc.dart';
import 'package:mycookcoach/features/location_espace/domain/usecases/book_kitchen_usecase.dart';
import 'package:mycookcoach/features/location_espace/domain/usecases/fetch_all_locations_usecase.dart';
import 'package:mycookcoach/features/location_espace/domain/usecases/fetch_bookings_by_kitchen_id_usecase.dart';
import 'package:mycookcoach/features/location_espace/domain/usecases/fetch_kitchens_by_local_id_usecase.dart';
import 'package:mycookcoach/features/location_espace/presentation/blocs/location_bloc/location_event.dart';
import 'package:mycookcoach/features/location_espace/presentation/blocs/location_bloc/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final FetchAllLocalsUseCase fetchAllLocalsUseCase;
  final FetchKitchensByLocalIdUseCase fetchKitchensByLocalIdUseCase;
  final BookKitchenUseCase bookKitchenUseCase;
  final FetchBookingsByKitchenIdUseCase fetchBookingsByKitchenIdUseCase;

  LocationBloc({
    required this.fetchAllLocalsUseCase,
    required this.fetchKitchensByLocalIdUseCase,
    required this.bookKitchenUseCase,
    required this.fetchBookingsByKitchenIdUseCase,
  }) : super(LocationInitial()) {
    on<FetchAllLocalsEvent>((event, emit) async {
      emit(LocationLoading());
      final result = await fetchAllLocalsUseCase();
      result.fold(
        (failure) => emit(LocationError(failure.message)),
        (locals) => emit(LocalsLoaded(locals)),
      );
    });

    on<FetchKitchensByLocalIdEvent>((event, emit) async {
      emit(LocationLoading());
      final result = await fetchKitchensByLocalIdUseCase(event.localId);
      result.fold(
        (failure) => emit(LocationError(failure.message)),
        (kitchens) => emit(KitchensLoaded(kitchens)),
      );
    });

    on<BookKitchenEvent>((event, emit) async {
      emit(LocationLoading());
      final result = await bookKitchenUseCase(event.booking);
      result.fold(
        (failure) => emit(LocationError(failure.message)),
        (_) => emit(KitchenBooked()),
      );
    });

    on<FetchBookingsByKitchenIdEvent>((event, emit) async {
      emit(LocationLoading());
      final result = await fetchBookingsByKitchenIdUseCase(event.kitchenId);
      result.fold(
        (failure) => emit(LocationError(failure.message)),
        (bookings) => emit(BookingsLoaded(bookings)),
      );
    });
  }
}
