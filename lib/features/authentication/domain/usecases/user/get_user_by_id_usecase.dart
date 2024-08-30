import 'package:either_dart/src/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';
import 'package:mycookcoach/features/authentication/domain/repositories/user_repo.dart';



class GetUserByIdUseCase {
  final UserRepository _userRepository;

  GetUserByIdUseCase(this._userRepository);

  Future<Either<Failure, UserEntity>> execute(String userId) async {
    return await _userRepository.getUserById(userId);
  }
}
