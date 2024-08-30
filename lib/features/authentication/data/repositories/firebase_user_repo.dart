import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/core/utils/type_def.dart';
import 'package:mycookcoach/features/authentication/data/models/user.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';
import 'package:mycookcoach/features/authentication/domain/repositories/user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);

      myUser = myUser.copyWith(userId: user.user!.uid);

      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    final usersCollection = _firestore.collection('users');
    try {
      await usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  @override
  ResultFuture<UserEntity> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return Right(
            UserEntity.fromDocument(doc.data() as Map<String, dynamic>));
      } else {
        return Left(FireBaseFailure(
            message: 'No user found with ID: $userId', statusCode: 404));
      }
    } catch (e) {
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "Failed to fetch user: ${e.toString()}",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to get user with this ID: ${e.toString()}",
            statusCode: 500));
      }
    }
  }

  @override
  ResultVoid updateUser(UserEntity user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.userId)
          .update(user.toDocument());
      return const Right(null);
    } catch (e) {
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "Failed to update user: ${e.toString()}",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to update user : ${e.toString()}",
            statusCode: 500));
      }
    }
  }

  @override
  ResultFuture<List<UserEntity>> fetchUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      final teams = snapshot.docs
          .map((doc) => UserEntity.fromDocument(doc.data()))
          .toList();
      return Right(teams);
    } catch (e) {
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "An unknown error occurred with Firebase",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to fetch users: ${e.toString()}",
            statusCode: 500));
      }
    }
  }
}
