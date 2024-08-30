import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';
import 'package:mycookcoach/features/authentication/domain/usecases/user/fetch_all_users_usecase.dart';
import 'package:mycookcoach/features/authentication/domain/usecases/user/get_user_by_id_usecase.dart';
import 'package:mycookcoach/features/authentication/domain/usecases/user/update_user_data_usecase.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_event.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserByIdUseCase getUserByIdUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final FetchAllUsersUseCase fetchAllUsersUseCase;

  UserBloc({
    required this.getUserByIdUseCase,
    required this.updateUserUseCase,
    required this.fetchAllUsersUseCase,
  }) : super(UserInitial()) {
    on<GetUserById>(_onGetUserById);
    on<UpdateUser>(_onUpdateUser);
    on<FetchAllUsersEvent>((event, emit) => _loadAllUsers(emit));
  }

  Future<void> _onGetUserById(
      GetUserById event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final failureOrUser = await getUserByIdUseCase.execute(event.userId);
    emit(failureOrUser.fold(
          (failure) => UserErrorState(_mapFailureToMessage(failure)),
          (user) => UserLoaded(user),
    ));
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final failureOrSuccess = await updateUserUseCase.call(event.user);

    if (failureOrSuccess is Failure) {
      emit(UserErrorState(_mapFailureToMessage(failureOrSuccess.left)));
      return;
    }

    final refreshOrFailure =
    await getUserByIdUseCase.execute(event.user.userId);
    refreshOrFailure.fold(
          (failure) => emit(UserErrorState(_mapFailureToMessage(failure))),
          (updatedUser) => emit(UserUpdateSuccess(updatedUser)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case FireBaseFailure:
        return (failure as FireBaseFailure).message;
      default:
        return 'Unexpected error';
    }
  }

  void _loadAllUsers(Emitter<UserState> emit) async {
    emit(UserLoading());
    Either<Failure, List<UserEntity>> result =
    await fetchAllUsersUseCase.fetchTeams();

    result.fold((failure) {
      print("Error fetching users: ${failure.message}");
      emit(UserErrorState('Failed to fetch users: ${failure.message}'));
    }, (users) {
      print("Successfully fetched users: ${users.length} users found.");
      emit(UsersLoadedState(users));
    });
  }
}
