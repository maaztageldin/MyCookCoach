import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycookcoach/core/utils/utils.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/models/chat.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/models/message.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';

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
}
