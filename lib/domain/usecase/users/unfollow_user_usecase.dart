import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UnfollowUserByIdUseCase extends UseCase<String, Result<void>> {
  UnfollowUserByIdUseCase(this._usersRepository);

  final UsersRepository _usersRepository;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _usersRepository.unfollowUserById(id);
  }
}
