import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/repositories/chat_repository_Impl.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/repositories/favorite_repository_impl.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/repositories/formation_repository_impl.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/repositories/home_recipe_repository_impl.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/chat_usecases/get_chat_list_by_recipe_and_chef_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/favorite_usecase/add_favorite_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/favorite_usecase/get_favorite_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/favorite_usecase/remove_favorite_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/formations_usecase/enrollIn_formation_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/formations_usecase/get_formations_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/home_recipe_usecase/create_home_recipe_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/home_recipe_usecase/delete_home_recipe_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/home_recipe_usecase/fetch_all_home_recipe_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/home_recipe_usecase/get_home_recipe_by_id_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/home_recipe_usecase/update_home_recipe_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/chat_blocs/chat_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/favorite_blocs/favorite_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/formation_blocs/formation_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/home_recipe_blocs/home_recipe_bloc.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/authentication/domain/usecases/user/fetch_all_users_usecase.dart';
import 'package:mycookcoach/features/authentication/domain/usecases/user/get_user_by_id_usecase.dart';
import 'package:mycookcoach/features/authentication/domain/usecases/user/update_user_data_usecase.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/auth_blocs/auth_bloc.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_bloc.dart';
import 'package:mycookcoach/features/shop/data/repositories/cart_repository_impl.dart';
import 'package:mycookcoach/features/shop/data/repositories/kitchen_item_repository_impl.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/add_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/delete_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/get_cart_items_by_user_id_and_product_id_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/get_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/cart_items_usecase/update_cart_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/kitchen_items_usecases/add_kitchen_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/kitchen_items_usecases/delete_kitchen_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/kitchen_items_usecases/get_kitchen_items_usecase.dart';
import 'package:mycookcoach/features/shop/domain/usecases/kitchen_items_usecases/update_kitchen_items_usecase.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/kitchen_item_bloc/kitchen_item_bloc.dart';

List<BlocProvider> getAppBlocProviders() {
  final userRepository = FirebaseUserRepo();

  return [
    BlocProvider<AuthenticationBloc>(
      create: (_) => AuthenticationBloc(userRepository: userRepository),
    ),
    BlocProvider<SignInBloc>(
      create: (_) => SignInBloc(userRepository: userRepository),
    ),
    BlocProvider<SignUpBloc>(
      create: (_) => SignUpBloc(userRepository: userRepository),
    ),
    BlocProvider<UserBloc>(
      create: (_) => UserBloc(
        getUserByIdUseCase: GetUserByIdUseCase(FirebaseUserRepo()),
        updateUserUseCase: UpdateUserUseCase(FirebaseUserRepo()),
        fetchAllUsersUseCase: FetchAllUsersUseCase(FirebaseUserRepo()),
      ),
    ),
    BlocProvider<HomeRecipeBloc>(
      create: (context) => HomeRecipeBloc(
        getHomeRecipeByIdUseCase:
            GetHomeRecipeByIdUseCase(HomeRecipeRepositoryImpl()),
        createHomeRecipeUseCase:
            CreateHomeRecipeUseCase(HomeRecipeRepositoryImpl()),
        updateHomeRecipeUseCase:
            UpdateHomeRecipeUseCase(HomeRecipeRepositoryImpl()),
        deleteHomeRecipeUseCase:
            DeleteHomeRecipeUseCase(HomeRecipeRepositoryImpl()),
        fetchAllHomeRecipesUseCase:
            FetchAllHomeRecipesUseCase(HomeRecipeRepositoryImpl()),
      ),
    ),
    BlocProvider<ChatBloc>(
      create: (_) => ChatBloc(
        getChatListByRecipeAndChefUseCase: GetChatListByRecipeAndChefUseCase(
          repository: ChatRepositoryImpl(),
        ),
      ),
    ),
    BlocProvider<FavoriteBloc>(
      create: (_) => FavoriteBloc(
          addFavoriteUseCase: AddFavoriteUseCase(FavoriteRepositoryImpl()),
          removeFavoriteUseCase:
              RemoveFavoriteUseCase(FavoriteRepositoryImpl()),
          getFavoritesUseCase: GetFavoritesUseCase(FavoriteRepositoryImpl())),
    ),
    BlocProvider<FormationBloc>(
      create: (_) => FormationBloc(
        getFormationsUseCase:
            GetFormationsUseCase(repository: FormationRepositoryImpl()),
        enrollInFormationUseCase:
            EnrollInFormationUseCase(repository: FormationRepositoryImpl()),
      ),
    ),
    BlocProvider<KitchenItemBloc>(
      create: (_) => KitchenItemBloc(
          getKitchenItemsUseCase:
              GetKitchenItemsUseCase(repository: KitchenItemRepositoryImpl()),
          addKitchenItemUseCase:
              AddKitchenItemUseCase(repository: KitchenItemRepositoryImpl()),
          updateKitchenItemUseCase:
              UpdateKitchenItemUseCase(repository: KitchenItemRepositoryImpl()),
          deleteKitchenItemUseCase: DeleteKitchenItemUseCase(
              repository: KitchenItemRepositoryImpl())),
    ),
    BlocProvider<CartBloc>(
      create: (_) => CartBloc(
        getCartItemsUseCase: GetCartItemsUseCase(
          repository: CartRepositoryImpl(),
        ),
        addCartItemUseCase: AddCartItemUseCase(
          repository: CartRepositoryImpl(),
        ),
        updateCartItemUseCase: UpdateCartItemUseCase(
          repository: CartRepositoryImpl(),
        ),
        deleteCartItemUseCase: DeleteCartItemUseCase(
          repository: CartRepositoryImpl(),
        ),
        getCartItemByUserIdAndProductIdUseCase:
            GetCartItemByUserIdAndProductIdUseCase(
          cartRepository: CartRepositoryImpl(),
        ),
      ),
    ),
  ];
}
