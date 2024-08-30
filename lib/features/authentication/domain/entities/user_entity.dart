import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? pictureUrl;
  final String? role;

  const UserEntity({
    required this.userId,
    required this.email,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.pictureUrl,
    this.role,
  });

  UserEntity copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? pictureUrl,
    String? role,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      role: role ?? this.role,
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'pictureUrl': pictureUrl,
      'role': role,
    };
  }

  static UserEntity fromDocument(Map<String, dynamic> doc) {
    return UserEntity(
      userId: doc['userId'],
      email: doc['email'],
      firstName: doc['firstName'],
      lastName: doc['lastName'],
      birthDate: doc['birthDate'],
      pictureUrl: doc['pictureUrl'],
      role: doc['role'],
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
      ];
}
