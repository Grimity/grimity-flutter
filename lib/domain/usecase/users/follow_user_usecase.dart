import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FollowUserByIdUseCase extends UseCase<String, Result<void>> {
  FollowUserByIdUseCase(this._usersRepository);

  final UsersRepository _usersRepository;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _usersRepository.followUserById(id);
  }
}
