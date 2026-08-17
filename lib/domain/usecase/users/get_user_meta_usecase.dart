import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/data/service/users_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserMetaByUrlUseCase extends UseCase<String, Result<User>> {
  GetUserMetaByUrlUseCase(this._usersService);

  final UsersService _usersService;

  @override
  Future<Result<User>> execute(String request) async {
    return await _usersService.getMetaByUrl(request);
  }
}

@injectable
class GetUserMetaByIdUseCase extends UseCase<String, Result<User>> {
  GetUserMetaByIdUseCase(this._usersService);

  final UsersService _usersService;

  @override
  Future<Result<User>> execute(String request) async {
    return await _usersService.getMeta(request);
  }
}
