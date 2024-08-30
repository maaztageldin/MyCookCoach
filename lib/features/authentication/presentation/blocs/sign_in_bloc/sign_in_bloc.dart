import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/sign_in_bloc/sign_in_event.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/sign_in_bloc/sign_in_state.dart';

import '../../../domain/repositories/user_repo.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc({
    required UserRepository userRepository
  }) : _userRepository = userRepository,
        super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInProcess());
      try {
        await _userRepository.signIn(event.email, event.password);
        emit(SignInSuccess());
      } on FirebaseAuthException catch (e) {
        emit(SignInFailure(message: e.code));
      } catch (e) {
        emit(const SignInFailure());
      }
    });
    on<SignOutRequired>((event, emit) async {
      try {
        await _userRepository.logOut();
        emit(SignOutSuccessState());
      } catch (e) {
        emit(SignInFailure(message: e.toString()));
      }
    });
  }
}