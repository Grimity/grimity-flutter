import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPopularUsersUseCase extends NoParamUseCase<Result<Users>> {
  GetPopularUsersUseCase(this._usersRepository);

  final UsersRepository _usersRepository;

  @override
  Future<Result<Users>> execute() async {
    return await _usersRepository.getPopularUsers();
  }
}
