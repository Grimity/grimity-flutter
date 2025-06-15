import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserProfileByUrlUseCase extends UseCase<String, Result<User>> {
  GetUserProfileByUrlUseCase(this._usersRepository);

  final UsersRepository _usersRepository;

  @override
  Future<Result<User>> execute(String request) async {
    return await _usersRepository.getProfileByUrl(request);
  }
}

@injectable
class GetUserProfileByIdUseCase extends UseCase<String, Result<User>> {
  GetUserProfileByIdUseCase(this._usersRepository);

  final UsersRepository _usersRepository;

  @override
  Future<Result<User>> execute(String request) async {
    return await _usersRepository.getUserById(request);
  }
}
