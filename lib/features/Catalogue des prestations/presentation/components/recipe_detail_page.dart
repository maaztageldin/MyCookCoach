import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycookcoach/core/services/database_service.dart';
import 'package:mycookcoach/core/utils/chat_utile.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/home_recipe_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/chat/message_list_page.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';

class RecipeDetailPage extends StatelessWidget {
  final HomeRecipeEntity recipe;

  RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  final String currentUserId = FirebaseUserRepo().currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/shop/icons/back.svg',
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('recette'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () async {
              if (recipe.chefId == currentUserId) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageListPage(
                      recipeId: recipe.id,
                      chefId: recipe.chefId,
                    ),
                  ),
                );
              } else {
                ChatUtils().startChat(
                  context,
                  currentUserId,
                  recipe.chefId,
                  recipe.id,
                );
                // (BuildContext context, String currentUserId, String otherUserId, String recipeId)

                /*final chatExists = await _dataBaseService.checkChatExists(
                  currentUserId,
                  recipe.chefId,
                  recipe.id,
                );
                final UserEntity? currentUser =
                    await _dataBaseService.getUserById(currentUserId);
                final UserEntity? otherUser =
                    await _dataBaseService.getUserById(recipe.chefId);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      chatUserId: recipe.chefId,
                      currentUserEntity: otherUser!,
                      otherUserEntity: currentUser!,
                      recipeId: recipe.id,
                    ),
                  ),
                );
                if (!chatExists) {
                  await _dataBaseService.createNewChat(
                    currentUserId,
                    recipe.chefId,
                    recipe.id,
                  );
                }*/
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          // Main Image
          Container(
            height: 480,
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(recipe.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Text(
                  recipe.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Recipe Details
          const Text(
            "Descriptions : ",
            style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 8),

          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.man),
                  const SizedBox(width: 6),
                  Text(
                    recipe.chef,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: kTextLightColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.timer),
                  const SizedBox(width: 6),
                  Text(
                    recipe.duration,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: kTextLightColor),
                  ),
                  const SizedBox(width: 24),
                  Icon(Icons.people_outline_outlined),
                  const SizedBox(width: 6),
                  Text(
                    recipe.serving,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: kTextLightColor),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(recipe.description, style: TextStyle(color: kTextColor,)),
          const SizedBox(height: 45),
        ],
      ),
    );
  }
}
