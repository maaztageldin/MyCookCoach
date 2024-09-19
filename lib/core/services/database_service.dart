import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycookcoach/core/utils/utils.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/models/chat.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/models/message.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/kitchen_location_entity.dart';

class DataBaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _chatsCollection;

  DataBaseService() {
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _chatsCollection = _firebaseFirestore
        .collection('chats')
        .withConverter<Chat>(
            fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
            toFirestore: (chat, _) => chat.toJson());
  }

  Future<bool> checkChatExists(
      String uid1, String uid2, String recipeId) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2, recipeId: recipeId);
    final result = await _chatsCollection?.doc(chatID).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2, String recipeId) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2, recipeId: recipeId);
    final docRef = _chatsCollection!.doc(chatID);
    final chat = Chat(
        id: chatID,
        participants: [uid1, uid2],
        messages: [],
        recipeId: recipeId);
    await docRef.set(chat);
  }

  Future<UserEntity?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserEntity.fromDocument(doc.data() as Map<String, dynamic>);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message, String recipeId) async {
    String chatId = generateChatID(uid1: uid1, uid2: uid2, recipeId: recipeId);
    final docRef = _chatsCollection!.doc(chatId);
    await docRef.update({
      "messages": FieldValue.arrayUnion([
        message.toJson(),
      ])
    });
  }

  Stream<DocumentSnapshot<Chat>> getChatData(
      String uid1, String uid2, String recipeId) {
    String chatId = generateChatID(uid1: uid1, uid2: uid2, recipeId: recipeId);
    return _chatsCollection?.doc(chatId).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }

  Future<List<KitchenLocationEntity>> fetchKitchens(List<String> kitchenIds) async {
    final kitchens = <KitchenLocationEntity>[];

    try {
      for (var id in kitchenIds) {
        try {
          final doc = await _firebaseFirestore.collection('kitchens_to_book').doc(id).get();

          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;

            final availabilityPeriodsList = (data['availabilityPeriods'] as List<dynamic>?)
                ?.map((period) {
              try {
                final startDateTimestamp = period['start_date'] as Timestamp;
                final endDateTimestamp = period['end_date'] as Timestamp;

                final startDate = startDateTimestamp.toDate();
                final endDate = endDateTimestamp.toDate();

                final price = period['price'] as int;
                return {
                  'start_date': startDate,
                  'end_date': endDate,
                  'price': price
                };
              } catch (e) {
                print("Erreur lors du parsing des dates ou du prix pour la cuisine $id: $e");
                return {
                  'start_date': DateTime.now(),
                  'end_date': DateTime.now(),
                  'price': 0
                };
              }
            }).toList() ?? [];



            kitchens.add(KitchenLocationEntity(
              id: data['id'] ?? '',
              name: data['name'] ?? '',
              isAvailable: data['isAvailable'] ?? false,
              localId: data['localId'] ?? '',
              priceH: data['priceH'] ?? '',
              details: data['details'] ?? '',
              availabilityPeriods: availabilityPeriodsList,
              images: List<String>.from(data['images'] ?? []),
            ));
          } else {
            print("Le document pour la cuisine $id n'existe pas.");
          }
        } catch (e) {
          print("Erreur lors de la récupération des données pour la cuisine $id: $e");
        }
      }
    } catch (e) {
      print("Erreur inattendue lors de la récupération des cuisines: $e");
    }

    return kitchens;
  }
}
