import 'package:firebase_auth/firebase_auth.dart';
import 'package:mycookcoach/core/utils/type_def.dart';

import '../../data/models/user.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Stream<User?> get user;

  ResultFuture<UserEntity> getUserById(String userId);

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> setUserData(MyUser user);

  Future<void> signIn(String email, String password);

  Future<void> logOut();

  bool isLoggedIn();

  User? get currentUser;

  ResultVoid updateUser(UserEntity user);

  ResultFuture<List<UserEntity>> fetchUsers();
}
