

import 'package:mycookcoach/core/utils/type_def.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';
import 'package:mycookcoach/features/authentication/domain/repositories/user_repo.dart';

class FetchAllUsersUseCase {
  final UserRepository _userRepository;

  FetchAllUsersUseCase(this._userRepository);

  ResultFuture<List<UserEntity>> fetchTeams() {
    return _userRepository.fetchUsers();
  }
}
