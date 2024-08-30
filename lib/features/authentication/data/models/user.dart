import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';


class MyUser extends Equatable {
  final String userId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? pictureUrl;
  final String? role;
  /*final String? eval;
  final String? position;
  final List<String>? clubs;
  final List<String>? teams;*/

  const MyUser({
    required this.userId,
    required this.email,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.pictureUrl,
    this.role,
    /*this.eval,
    this.position,
    this.clubs,
    this.teams,*/
  });

  static const empty = MyUser(
    userId: '',
    email: '',
    lastName: '',
    firstName: '',
    birthDate: '',
    pictureUrl: '',
    role: '',
    /*eval: '',
    position: '',
    clubs: [],
    teams: [],*/
  );

  MyUser copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? pictureUrl,
    String? role,
   /* String? eval,
    String? position,
    List<String>? clubs,
    List<String>? teams,*/
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      role: role ?? this.role,
      /*eval: eval ?? this.eval,
      position: position ?? this.position,
      clubs: clubs ?? this.clubs,
      teams: teams ?? this.teams,*/
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      pictureUrl: pictureUrl,
      role: role,
      /*eval: eval,
      position: position,
      clubs: clubs,
      teams: teams,*/
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        firstName,
        lastName,
        birthDate,
        pictureUrl,
        role,
       /* eval,
        position,
        clubs,
        teams,*/
      ];
}
