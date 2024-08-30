import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/favorite_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/favorite_usecase/add_favorite_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/favorite_usecase/get_favorite_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/favorite_usecase/remove_favorite_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/favorite_blocs/favorite_state.dart';
import 'favorite_event.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final AddFavoriteUseCase addFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;

  FavoriteBloc({
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
    required this.getFavoritesUseCase,
  }) : super(FavoriteLoading()) {
    on<AddFavorite>((event, emit) async {
      try {
        final favorite = FavoriteEntity(
          id: event.recipeId,
          userId: event.userId,
          recipeId: event.recipeId,
          type: event.type,
        );
        await addFavoriteUseCase.call(favorite);
        emit(FavoriteAdded(favorite));
      } catch (_) {
        emit(FavoriteError('Failed to add favorite'));
      }
    });

    on<RemoveFavorite>((event, emit) async {
      try {
        await removeFavoriteUseCase.call(event.recipeId, event.userId);
        emit(FavoriteRemoved(event.recipeId, event.userId));
      } catch (_) {
        emit(FavoriteError('Failed to remove favorite'));
      }
    });

    on<GetFavorites>((event, emit) async {
      emit(FavoriteLoading());
      try {
        final result = await getFavoritesUseCase.call(event.userId);
        result.fold(
              (failure) => emit(FavoriteError('Failed to fetch favorites')),
              (favorites) => emit(FavoriteLoaded(favorites)),
        );
      } catch (_) {
        emit(FavoriteError('Failed to fetch favorites'));
      }
    });
  }
}
