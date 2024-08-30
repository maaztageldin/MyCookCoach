import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserEntity user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserUpdateSuccess extends UserState {
  final UserEntity updatedUser;

  UserUpdateSuccess(this.updatedUser);
}

class UserErrorState extends UserState {
  final String message;

  const UserErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class UsersLoadedState extends UserState {
  final List<UserEntity> users;

  const UsersLoadedState(this.users);
  @override
  List<Object?> get props => [users];
}

class UsersByIdsLoaded extends UserState {
  final List<UserEntity> users;

  UsersByIdsLoaded(this.users);
}

class UserUpdatedState extends UserState {
  final UserEntity user;

  UserUpdatedState({required this.user});
}

