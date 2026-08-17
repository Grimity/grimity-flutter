import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/data/service/users_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPopularUsersUseCase extends NoParamUseCase<Result<Users>> {
  GetPopularUsersUseCase(this._usersService);

  final UsersService _usersService;

  @override
  Future<Result<Users>> execute() async {
    return await _usersService.getPopularUsers();
  }
}
