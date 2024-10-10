import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/favorite_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/favorite_blocs/favorite_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/favorite_blocs/favorite_event.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/favorite_blocs/favorite_state.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/home_recipe_blocs/home_recipe_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/home_recipe_blocs/home_recipe_event.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/home_recipe_blocs/home_recipe_state.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/components/favorite_item_card.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late String userId;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() {
    final currentUser = FirebaseUserRepo().currentUser;
    if (currentUser != null) {
      userId = currentUser.uid;
      context.read<FavoriteBloc>().add(GetFavorites(userId));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Utilisateur non connecté'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: Center(
              child: Text(
                'Mes Favoris',
                style: TextStyle(color: Colors.black),
              ),
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state is FavoriteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kMainColor),
            );
          } else if (state is FavoriteLoaded) {
            return _buildFavoritesList(state.favorites);
          } else {
            return const Center(
              child: Text('Aucun favori disponible.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildFavoritesList(List<FavoriteEntity> favorites) {
    if (favorites.isEmpty) {
      return const Center(child: Text('Aucun favori trouvé.'));
    }

    final recipeIds = favorites.map((favorite) => favorite.recipeId).toList();

    // Charger les recettes par ID dans le bloc
    context.read<HomeRecipeBloc>().add(GetRecipesByIdList(recipeIds));

    return BlocBuilder<HomeRecipeBloc, HomeRecipeState>(
      builder: (context, state) {
        if (state is HomeRecipeLoading) {
          return const Center(
              child: CircularProgressIndicator(color: kMainColor));
        } else if (state is HomeRecipesLoadedByIds) {
          final recipes = state.recipes;

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return FavoriteItemCard(recipe: recipes[index]!);
            },
          );
        } else {
          return const Center(
              child: Text('Erreur lors du chargement des recettes.'));
        }
      },
    );
  }
}
