import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/add_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/clear_cart_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/delete_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/get_cart_items_by_user_id_and_product_id_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/get_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/remove_cart_items_quantity_by_id_and_userid_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/update_cart_items_quantity_by_id_and_userid_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/update_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddCartItemUseCase addCartItemUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final DeleteCartItemUseCase deleteCartItemUseCase;
  final GetCartItemByUserIdAndProductIdUseCase
      getCartItemByUserIdAndProductIdUseCase;
  final UpdateCartItemQuantityByIdAndUserIdUseCase
      updateCartItemQuantityByIdAndUserIdUseCase;
  final RemoveCartItemByIdAndUserIdUseCase removeCartItemByIdAndUserIdUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartBloc({
    required this.getCartItemsUseCase,
    required this.addCartItemUseCase,
    required this.updateCartItemUseCase,
    required this.deleteCartItemUseCase,
    required this.getCartItemByUserIdAndProductIdUseCase,
    required this.updateCartItemQuantityByIdAndUserIdUseCase,
    required this.removeCartItemByIdAndUserIdUseCase,
    required this.clearCartUseCase,
  }) : super(CartLoadingState()) {
    on<FetchCartItemsByUserIdEvent>(_onFetchCartItems);
    on<AddCartItemEvent>(_onAddCartItem);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<DeleteCartItemEvent>(_onDeleteCartItem);
    on<RecalculateTotalEvent>(_onRecalculateTotal);
    on<GetCartItemByUserIdAndProductIdEvent>(
        _onGetCartItemByUserIdAndProductId);
    on<UpdateCartItemQuantityByIdAndUserIdEvent>(
        _onUpdateCartItemQuantityByIdAndUserId);
    on<RemoveCartItemByIdAndUserIdEvent>(_onRemoveCartItemByIdAndUserId);
    on<ClearCartByUserIdAndProductIdEvent>(_clearCartByUserIdAndProductId);
  }

  Future<void> _onFetchCartItems(
    FetchCartItemsByUserIdEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final items = await getCartItemsUseCase.call(event.userId);
      emit(CartsLoadedState(items: items));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> _onAddCartItem(
    AddCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      await addCartItemUseCase.call(event.item);
      emit(CartSuccessState(message: 'Article ajouté au panier avec succès'));
      add(FetchCartItemsByUserIdEvent(userId: event.item.userId));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      await updateCartItemUseCase.call(event.item);
      emit(CartSuccessState(message: 'Article mis à jour avec succès'));
      add(FetchCartItemsByUserIdEvent(userId: event.item.userId));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeleteCartItem(
    DeleteCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      await deleteCartItemUseCase.call(event.itemId);
      emit(CartSuccessState(message: 'Article supprimé du panier avec succès'));
      add(FetchCartItemsByUserIdEvent(userId: event.userId));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> _onRecalculateTotal(
    RecalculateTotalEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final cartItems = await getCartItemsUseCase.call(event.userId);
      final item = cartItems.firstWhere((item) => item.id == event.productId);

      if (event.quantity > item.stockQuantity) {
        emit(CartErrorState(
            message: 'La quantité choisie dépasse le stock disponible.'));
        return;
      }

      final updatedItem = item.copyWith(quantity: event.quantity);
      await updateCartItemUseCase.call(updatedItem);
      add(FetchCartItemsByUserIdEvent(userId: event.userId));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> _onGetCartItemByUserIdAndProductId(
    GetCartItemByUserIdAndProductIdEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final item = await getCartItemByUserIdAndProductIdUseCase.call(
          event.userId, event.productId);
      if (item != null) {
        emit(CartItemLoadedState(item: item));
      } else {
        emit(CartItemNotFoundState());
      }
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  void _onUpdateCartItemQuantityByIdAndUserId(
      UpdateCartItemQuantityByIdAndUserIdEvent event,
      Emitter<CartState> emit) async {
    try {
      await updateCartItemQuantityByIdAndUserIdUseCase.call(
          event.productId, event.userId, event.newQuantity);
      add(FetchCartItemsByUserIdEvent(userId: event.userId));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  void _onRemoveCartItemByIdAndUserId(
      RemoveCartItemByIdAndUserIdEvent event, Emitter<CartState> emit) async {
    try {
      await removeCartItemByIdAndUserIdUseCase.call(
          event.productId, event.userId);
      add(FetchCartItemsByUserIdEvent(userId: event.userId));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> _clearCartByUserIdAndProductId(
      ClearCartByUserIdAndProductIdEvent event, // Correct event type
      Emitter<CartState> emit,
      ) async {
    try {
      await clearCartUseCase.call(event.userId);
      emit(CartSuccessState(message: 'Panier supprimé avec succès'));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }
}
