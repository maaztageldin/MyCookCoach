
import 'package:mycookcoach/core/utils/type_def.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';
import 'package:mycookcoach/features/authentication/domain/repositories/user_repo.dart';

class UpdateUserUseCase {
  final UserRepository _userRepository;

  UpdateUserUseCase(this._userRepository);

  ResultVoid call(UserEntity params) async =>
      _userRepository.updateUser(params);
}
