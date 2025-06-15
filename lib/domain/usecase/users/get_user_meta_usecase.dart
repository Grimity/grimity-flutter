import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserMetaByUrlUseCase extends UseCase<String, Result<User>> {
  GetUserMetaByUrlUseCase(this._usersRepository);

  final UsersRepository _usersRepository;

  @override
  Future<Result<User>> execute(String request) async {
    return await _usersRepository.getMetaByUrl(request);
  }
}

@injectable
class GetUserMetaByIdUseCase extends UseCase<String, Result<User>> {
  GetUserMetaByIdUseCase(this._usersRepository);

  final UsersRepository _usersRepository;

  @override
  Future<Result<User>> execute(String request) async {
    return await _usersRepository.getMeta(request);
  }
}
