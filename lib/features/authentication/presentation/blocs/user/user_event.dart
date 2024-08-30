import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserById extends UserEvent {
  final String userId;

  const GetUserById(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateUser extends UserEvent {
  final UserEntity user;

  const UpdateUser(this.user);

  @override
  List<Object> get props => [user];
}

class FetchAllUsersEvent extends UserEvent {}

class GetUsersByIds extends UserEvent {
  final List<String> userIds;

  GetUsersByIds(this.userIds);
}

class AddClubToUserEvent extends UserEvent {
  final String userId;
  final String clubId;

  const AddClubToUserEvent({required this.userId, required this.clubId});

  @override
  List<Object> get props => [userId, clubId];
}
