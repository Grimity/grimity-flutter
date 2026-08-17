import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/users_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class NameCheckUseCase extends UseCase<String, Result<void>> {
  NameCheckUseCase(this._usersService);

  final UsersService _usersService;

  @override
  Future<Result<void>> execute(String request) async {
    return await _usersService.nameCheck(request);
  }
}
