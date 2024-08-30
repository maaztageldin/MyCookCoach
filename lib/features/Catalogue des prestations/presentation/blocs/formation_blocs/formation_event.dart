import 'package:equatable/equatable.dart';

abstract class FormationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchFormationsEvent extends FormationEvent {}

class EnrollInFormationEvent extends FormationEvent {
  final String userId;
  final String formationId;

  EnrollInFormationEvent({
    required this.userId,
    required this.formationId,
  });

  @override
  List<Object?> get props => [userId, formationId];
}
