import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchUserUseCase extends UseCase<SearchUserRequestParams, Result<Users>> {
  SearchUserUseCase(this._usersRepository);

  final UsersRepository _usersRepository;

  @override
  Future<Result<Users>> execute(SearchUserRequestParams request) async {
    return await _usersRepository.searchUser(request);
  }
}