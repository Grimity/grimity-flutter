import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase extends UseCase<LoginRequestParam, Result<void>> {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<Token>> execute(LoginRequestParam request) async {
    return _authRepository.login(request);
  }
}

class LoginRequestParam {
  final String id;
  final String password;

  LoginRequestParam({required this.id, required this.password});
}
