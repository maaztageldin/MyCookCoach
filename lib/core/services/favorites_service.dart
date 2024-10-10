import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/home_recipe_entity.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<HomeRecipeEntity>> fetchRecipes() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('recipes').get();
      final List<HomeRecipeEntity> recipes = snapshot.docs.map((doc) {
        return HomeRecipeEntity.fromDocument(doc.data() as Map<String, dynamic>);
      }).toList();
      return recipes;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des recettes: $e');
    }
  }

  Future<HomeRecipeEntity?> fetchRecipeById(String recipeId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('recipes')
          .doc(recipeId)
          .get();

      if (doc.exists) {
        return HomeRecipeEntity.fromDocument(doc.data() as Map<String, dynamic>);
      } else {
        print('Recette non trouvée');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération de la recette: $e');
      return null;
    }
  }
}
