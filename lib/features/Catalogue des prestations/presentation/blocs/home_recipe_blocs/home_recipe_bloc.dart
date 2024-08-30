import 'package:bloc/bloc.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/home_recipe_usecase/create_home_recipe_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/home_recipe_usecase/delete_home_recipe_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/home_recipe_usecase/fetch_all_home_recipe_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/home_recipe_usecase/get_home_recipe_by_id_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/home_recipe_usecase/update_home_recipe_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/home_recipe_blocs/home_recipe_event.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/home_recipe_blocs/home_recipe_state.dart';

class HomeRecipeBloc extends Bloc<HomeRecipeEvent, HomeRecipeState> {
  final GetHomeRecipeByIdUseCase getHomeRecipeByIdUseCase;
  final CreateHomeRecipeUseCase createHomeRecipeUseCase;
  final UpdateHomeRecipeUseCase updateHomeRecipeUseCase;
  final DeleteHomeRecipeUseCase deleteHomeRecipeUseCase;
  final FetchAllHomeRecipesUseCase fetchAllHomeRecipesUseCase;

  HomeRecipeBloc({
    required this.getHomeRecipeByIdUseCase,
    required this.createHomeRecipeUseCase,
    required this.updateHomeRecipeUseCase,
    required this.deleteHomeRecipeUseCase,
    required this.fetchAllHomeRecipesUseCase,
  }) : super(HomeRecipeInitial()) {
    on<GetHomeRecipeById>(_onGetHomeRecipeById);
    on<CreateHomeRecipe>(_onCreateHomeRecipe);
    on<UpdateHomeRecipe>(_onUpdateHomeRecipe);
    on<DeleteHomeRecipe>(_onDeleteHomeRecipe);
    on<FetchAllHomeRecipes>(_onFetchAllHomeRecipes);
  }

  Future<void> _onGetHomeRecipeById(
      GetHomeRecipeById event, Emitter<HomeRecipeState> emit) async {
    emit(HomeRecipeLoading());
    final failureOrRecipe = await getHomeRecipeByIdUseCase.execute(event.recipeId);
    emit(failureOrRecipe.fold(
          (failure) => HomeRecipeOperationFailure(_mapFailureToMessage(failure)),
          (recipe) => HomeRecipeLoaded(recipe),
    ));
  }

  Future<void> _onCreateHomeRecipe(
      CreateHomeRecipe event, Emitter<HomeRecipeState> emit) async {
    emit(HomeRecipeLoading());
    final failureOrSuccess = await createHomeRecipeUseCase.execute(event.recipe);

    emit(failureOrSuccess.fold(
          (failure) => HomeRecipeOperationFailure(_mapFailureToMessage(failure)),
          (_) => HomeRecipeOperationSuccess(),
    ));
  }

  Future<void> _onUpdateHomeRecipe(
      UpdateHomeRecipe event, Emitter<HomeRecipeState> emit) async {
    emit(HomeRecipeLoading());
    final failureOrSuccess = await updateHomeRecipeUseCase.execute(event.recipe);

    emit(failureOrSuccess.fold(
          (failure) => HomeRecipeOperationFailure(_mapFailureToMessage(failure)),
          (_) => HomeRecipeOperationSuccess(),
    ));
  }

  Future<void> _onDeleteHomeRecipe(
      DeleteHomeRecipe event, Emitter<HomeRecipeState> emit) async {
    emit(HomeRecipeLoading());
    final failureOrSuccess = await deleteHomeRecipeUseCase.execute(event.recipeId);

    emit(failureOrSuccess.fold(
          (failure) => HomeRecipeOperationFailure(_mapFailureToMessage(failure)),
          (_) => HomeRecipeOperationSuccess(),
    ));
  }

  Future<void> _onFetchAllHomeRecipes(
      FetchAllHomeRecipes event, Emitter<HomeRecipeState> emit) async {
    emit(HomeRecipeLoading());
    final failureOrRecipes = await fetchAllHomeRecipesUseCase.execute();

    emit(failureOrRecipes.fold(
            (failure) => HomeRecipeOperationFailure(_mapFailureToMessage(failure)),
            (recipes) {

          final desserts = recipes.where((recipe) => recipe.category.toLowerCase() == "dessert").toList();
          final plats = recipes.where((recipe) => recipe.category.toLowerCase() != "dessert").toList();
          return HomeRecipesLoaded(desserts: desserts, plats: plats);
        }
    ));
  }


  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case FireBaseFailure:
        return (failure as FireBaseFailure).message;
      default:
        return 'Unexpected error';
    }
  }
}
