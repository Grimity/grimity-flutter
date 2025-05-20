import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class NameCheckUseCase extends UseCase<String, Result<void>> {
  NameCheckUseCase(this._usersRepository);

  final UsersRepository _usersRepository;

  @override
  Future<Result<void>> execute(String request) async {
    return await _usersRepository.nameCheck(request);
  }
}
