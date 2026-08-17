import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/data/service/users_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserProfileByUrlUseCase extends UseCase<String, Result<User>> {
  GetUserProfileByUrlUseCase(this._usersService);

  final UsersService _usersService;

  @override
  Future<Result<User>> execute(String request) async {
    return await _usersService.getProfileByUrl(request);
  }
}

@injectable
class GetUserProfileByIdUseCase extends UseCase<String, Result<User>> {
  GetUserProfileByIdUseCase(this._usersService);

  final UsersService _usersService;

  @override
  Future<Result<User>> execute(String request) async {
    return await _usersService.getUserById(request);
  }
}
