import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/formations_usecase/enrollIn_formation_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/formations_usecase/get_formations_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/formation_blocs/formation_event.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/formation_blocs/formation_state.dart';


class FormationBloc extends Bloc<FormationEvent, FormationState> {
  final GetFormationsUseCase getFormationsUseCase;
  final EnrollInFormationUseCase enrollInFormationUseCase;

  FormationBloc({
    required this.getFormationsUseCase,
    required this.enrollInFormationUseCase,
  }) : super(FormationLoadingState()) {
    on<FetchFormationsEvent>(_onFetchFormations);
    on<EnrollInFormationEvent>(_onEnrollInFormation);
  }

  Future<void> _onFetchFormations(
      FetchFormationsEvent event,
      Emitter<FormationState> emit,
      ) async {
    try {
      final formations = await getFormationsUseCase.call();
      emit(FormationLoadedState(formations: formations));
    } catch (e) {
      emit(FormationErrorState(message: e.toString()));
    }
  }

  Future<void> _onEnrollInFormation(
      EnrollInFormationEvent event,
      Emitter<FormationState> emit,
      ) async {
    try {
      await enrollInFormationUseCase.call(event.userId, event.formationId);
      emit(FormationEnrolledState());
    } catch (e) {
      emit(FormationErrorState(message: e.toString()));
    }
  }
}
