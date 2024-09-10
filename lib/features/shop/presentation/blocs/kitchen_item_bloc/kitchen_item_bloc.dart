import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/features/shop/domain/usecases/kitchen_items_usecases/add_kitchen_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/kitchen_items_usecases/delete_kitchen_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/kitchen_items_usecases/get_kitchen_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/kitchen_items_usecases/update_kitchen_items_usecase.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/kitchen_item_bloc/kitchen_item_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/kitchen_item_bloc/kitchen_item_state.dart';

class KitchenItemBloc extends Bloc<KitchenItemEvent, KitchenItemState> {
  final GetKitchenItemsUseCase getKitchenItemsUseCase;
  final AddKitchenItemUseCase addKitchenItemUseCase;
  final UpdateKitchenItemUseCase updateKitchenItemUseCase;
  final DeleteKitchenItemUseCase deleteKitchenItemUseCase;

  KitchenItemBloc({
    required this.getKitchenItemsUseCase,
    required this.addKitchenItemUseCase,
    required this.updateKitchenItemUseCase,
    required this.deleteKitchenItemUseCase,
  }) : super(KitchenItemLoadingState()) {
    on<FetchKitchenItemsEvent>(_onFetchKitchenItems);
    on<AddKitchenItemEvent>(_onAddKitchenItem);
    on<UpdateKitchenItemEvent>(_onUpdateKitchenItem);
    on<DeleteKitchenItemEvent>(_onDeleteKitchenItem);
    on<FetchKitchenItemsByCategoryEvent>(_onFetchKitchenItemsByCategory);
  }

  Future<void> _onFetchKitchenItems(
    FetchKitchenItemsEvent event,
    Emitter<KitchenItemState> emit,
  ) async {
    try {
      final items = await getKitchenItemsUseCase.call();
      emit(KitchenItemLoadedState(items: items));
    } catch (e) {
      emit(KitchenItemErrorState(message: e.toString()));
    }
  }

  Future<void> _onAddKitchenItem(
    AddKitchenItemEvent event,
    Emitter<KitchenItemState> emit,
  ) async {
    try {
      await addKitchenItemUseCase.call(event.item);
      emit(KitchenItemSuccessState(message: 'Article ajouté avec succès'));
      add(FetchKitchenItemsEvent());
    } catch (e) {
      emit(KitchenItemErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateKitchenItem(
    UpdateKitchenItemEvent event,
    Emitter<KitchenItemState> emit,
  ) async {
    try {
      await updateKitchenItemUseCase.call(event.item);
      emit(KitchenItemSuccessState(message: 'Article mis à jour avec succès'));
      add(FetchKitchenItemsEvent());
    } catch (e) {
      emit(KitchenItemErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeleteKitchenItem(
    DeleteKitchenItemEvent event,
    Emitter<KitchenItemState> emit,
  ) async {
    try {
      await deleteKitchenItemUseCase.call(event.itemId);
      emit(KitchenItemSuccessState(message: 'Article supprimé avec succès'));
      add(FetchKitchenItemsEvent());
    } catch (e) {
      emit(KitchenItemErrorState(message: e.toString()));
    }
  }

  Future<void> _onFetchKitchenItemsByCategory(
    FetchKitchenItemsByCategoryEvent event,
    Emitter<KitchenItemState> emit,
  ) async {
    try {
      String category = '';

      switch (event.categoryIndex) {
        case 0:
          category = "Ustensiles";
          break;
        case 1:
          category = "Électroménagers";
          break;
        case 2:
          category = "Outils de Découpe";
          break;
        case 3:
          category = "Rangement et Conservation";
          break;
        case 4:
          category = "Matériel de Pâtisserie";
          break;
        default:
          category = "Tous";
      }
      final items = await getKitchenItemsUseCase.fetchByCategory(category);

      emit(KitchenItemLoadedState(items: items));
    } catch (e) {
      emit(KitchenItemErrorState(message: e.toString()));
    }
  }
}
