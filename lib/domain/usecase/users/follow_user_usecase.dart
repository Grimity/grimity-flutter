import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/users_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class FollowUserByIdUseCase extends UseCase<String, Result<void>> {
  FollowUserByIdUseCase(this._usersService);

  final UsersService _usersService;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _usersService.followUserById(id);
  }
}
