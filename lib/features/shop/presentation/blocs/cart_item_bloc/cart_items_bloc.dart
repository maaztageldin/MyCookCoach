import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/add_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/delete_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/get_cart_items_by_user_id_and_product_id_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/get_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/update_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddCartItemUseCase addCartItemUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final DeleteCartItemUseCase deleteCartItemUseCase;
  final GetCartItemByUserIdAndProductIdUseCase getCartItemByUserIdAndProductIdUseCase;

  CartBloc({
    required this.getCartItemsUseCase,
    required this.addCartItemUseCase,
    required this.updateCartItemUseCase,
    required this.deleteCartItemUseCase,
    required this.getCartItemByUserIdAndProductIdUseCase,
  }) : super(CartLoadingState()) {
    on<FetchCartItemsEvent>(_onFetchCartItems);
    on<AddCartItemEvent>(_onAddCartItem);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<DeleteCartItemEvent>(_onDeleteCartItem);
    on<RecalculateTotalEvent>(_onRecalculateTotal);
    on<GetCartItemByUserIdAndProductIdEvent>(_onGetCartItemByUserIdAndProductId);
  }

  Future<void> _onFetchCartItems(
      FetchCartItemsEvent event,
      Emitter<CartState> emit,
      ) async {
    try {
      final items = await getCartItemsUseCase.call();
      emit(CartLoadedState(items: items));
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
      add(FetchCartItemsEvent());
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
      add(FetchCartItemsEvent());
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
      add(FetchCartItemsEvent());
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }


  Future<void> _onRecalculateTotal(
      RecalculateTotalEvent event,
      Emitter<CartState> emit,
      ) async {
    try {
      final cartItems = await getCartItemsUseCase.call();
      final item = cartItems.firstWhere((item) => item.id == event.productId);

      if (event.quantity > item.stockQuantity) {
        emit(CartErrorState(message: 'La quantité choisie dépasse le stock disponible.'));
        return;
      }

      final updatedItem = item.copyWith(quantity: event.quantity);
      await updateCartItemUseCase.call(updatedItem);

      emit(CartSuccessState(message: 'Quantité mise à jour avec succès'));
      add(FetchCartItemsEvent());
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }


  Future<void> _onGetCartItemByUserIdAndProductId(
      GetCartItemByUserIdAndProductIdEvent event,
      Emitter<CartState> emit,
      ) async {
    try {
      final item = await getCartItemByUserIdAndProductIdUseCase.call(event.userId, event.productId);
      if (item != null) {
        emit(CartItemLoadedState(item: item));
      } else {
        emit(CartItemNotFoundState());
      }
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }
}
