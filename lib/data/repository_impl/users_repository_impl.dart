import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/users_api.dart';
import 'package:grimity/domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UsersRepository)
class UsersRepositoryImpl extends UsersRepository {
  final UsersAPI _usersAPI;

  UsersRepositoryImpl(this._usersAPI);

  @override
  Future<Result<void>> nameCheck(String name) async {
    try {
      await _usersAPI.nameCheck({'name': name});
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
