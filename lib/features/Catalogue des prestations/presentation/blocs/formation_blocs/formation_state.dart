import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/formation_entity.dart';

abstract class FormationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FormationLoadingState extends FormationState {}

class FormationLoadedState extends FormationState {
  final List<FormationEntity> formations;

  FormationLoadedState({required this.formations});

  @override
  List<Object?> get props => [formations];
}

class FormationEnrolledState extends FormationState {}

class FormationErrorState extends FormationState {
  final String message;

  FormationErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
