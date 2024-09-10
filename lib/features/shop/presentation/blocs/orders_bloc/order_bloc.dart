import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/features/shop/domain/entities/order_entity.dart';
import 'package:mycookcoach/features/shop/domain/usecases/orders_usecases/create_order.dart';
import 'package:mycookcoach/features/shop/domain/usecases/orders_usecases/load_orders_ues_case.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/orders_bloc/order_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/orders_bloc/order_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final CreateOrderUesCase createOrderUseCase;
  final LoadOrdersUesCase loadOrdersUesCase;

  PurchaseBloc({
    required this.createOrderUseCase,
    required this.loadOrdersUesCase,
  }) : super(PurchaseInitial()) {
    on<PaymentConfirmed>(_onPaymentConfirmed);
    on<LoadOrders>(_loadOrdersUesCase);
  }


  void _onPaymentConfirmed(
      PaymentConfirmed event, Emitter<PurchaseState> emit) async {
    emit(PurchaseLoading());

    try {
      final order = OrderEntity(
        userId: event.userId,
        products: event.products,
        totalPrice: event.totalPrice,
        orderDate: DateTime.now(),
        status: 'pending',
        fullName: event.fullName,
        shippingAddress: event.shippingAddress,
        city: event.city,
        postalCode: event.postalCode,
        orderNumber: event.orderNumber,
      );

      await createOrderUseCase(order);
      emit(PurchaseSuccess());
    } catch (e) {
      emit(PurchaseFailure(e.toString()));
    }
  }

  Future<void> _loadOrdersUesCase(LoadOrders event, Emitter<PurchaseState> emit) async {
    emit(PurchaseLoading());

    try {
      final items = await loadOrdersUesCase.call(event.userId);
      emit(OrdersLoaded(items: items));
    } catch (e) {
      emit(PurchaseFailure(e.toString()));
    }
  }
}
