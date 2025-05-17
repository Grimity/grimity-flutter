import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginWithOAuthUseCase extends UseCase<LoginProvider, Result<String>> {
  LoginWithOAuthUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<String>> execute(LoginProvider request) async {
    return await _authRepository.loginWithOAuth(request);
  }
}
