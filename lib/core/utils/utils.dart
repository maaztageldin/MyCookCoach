String generateChatID({required String uid1, required String uid2, required String recipeId}) {
  List uids = [uid1, uid2, recipeId];
  uids.sort();
  String chatID = uids.fold("", (id, uid) => "$id$uid");
  return chatID;
}
