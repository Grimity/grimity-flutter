import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/data/service/users_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchUserUseCase extends UseCase<SearchUserRequestParams, Result<Users>> {
  SearchUserUseCase(this._usersService);

  final UsersService _usersService;

  @override
  Future<Result<Users>> execute(SearchUserRequestParams request) async {
    return await _usersService.searchUser(request);
  }
}
