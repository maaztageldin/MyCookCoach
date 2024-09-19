import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/home_recipe_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/favorite_blocs/favorite_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/favorite_blocs/favorite_event.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/favorite_blocs/favorite_state.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/home_recipe_blocs/home_recipe_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/home_recipe_blocs/home_recipe_event.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/home_recipe_blocs/home_recipe_state.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/components/recipe_detail_page.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';

class RecipeInfo extends StatefulWidget {
  const RecipeInfo({super.key, required this.user});

  final UserEntity user;

  @override
  State<RecipeInfo> createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
  @override
  void initState() {
    super.initState();
    context.read<HomeRecipeBloc>().add(FetchAllHomeRecipes());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeRecipeBloc, HomeRecipeState>(
      listener: (context, state) {
        if (state is HomeRecipeOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is HomeRecipesLoaded) {
          return Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 18,
                bottom: MediaQuery.of(context).padding.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      widget.user.firstName! + " " + widget.user.lastName!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Color(0xFF8B4513)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Qu'est-ce que vous voulez cuisiner aujourd’hui?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dessert",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 280,
                    child: ListView.separated(
                      itemCount: state.desserts.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      separatorBuilder: (_, __) {
                        return const SizedBox(width: 16);
                      },
                      itemBuilder: (context, index) {
                        final recipe = state.desserts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailPage(recipe: recipe),
                              ),
                            );
                          },
                          child: RecipeItem(
                            recipe: recipe,
                            userId: widget.user.userId,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Plats",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 280,
                    child: ListView.separated(
                      itemCount: state.plats.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      separatorBuilder: (_, __) {
                        return const SizedBox(width: 16);
                      },
                      itemBuilder: (context, index) {
                        final recipe = state.plats[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailPage(recipe: recipe),
                              ),
                            );
                          },
                          child: RecipeItem(
                            recipe: recipe,
                            userId: widget.user.userId,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(color: kMainColor));
        }
      },
    );
  }
}

class RecipeItem extends StatefulWidget {
  final HomeRecipeEntity recipe;
  final String userId;

  const RecipeItem({super.key, required this.recipe, required this.userId});

  @override
  State<RecipeItem> createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(GetFavorites(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        if (state is FavoriteLoaded) {
          isFavorite = state.favorites
              .any((favorite) => favorite.recipeId == widget.recipe.id);
        }

        return SizedBox(
          height: 280,
          width: 220,
          child: Stack(
            children: [
              Container(
                height: 280,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(widget.recipe.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.recipe.category,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.recipe.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.white),
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isFavorite) {
                                      context.read<FavoriteBloc>().add(
                                          RemoveFavorite(
                                              widget.recipe.id, widget.userId));
                                      isFavorite = true;
                                    } else {
                                      context.read<FavoriteBloc>().add(
                                          AddFavorite(widget.recipe.id,
                                              'recipe', widget.userId));
                                      isFavorite = false;
                                    }
                                    isFavorite = !isFavorite;
                                  });
                                },
                                child: Icon(
                                  isFavorite
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${widget.recipe.duration} | ${widget.recipe.serving}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
