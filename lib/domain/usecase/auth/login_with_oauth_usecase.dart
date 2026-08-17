import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/data/service/auth_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginWithOAuthUseCase extends UseCase<LoginProvider, Result<String>> {
  LoginWithOAuthUseCase(this._authService);

  final AuthService _authService;

  @override
  Future<Result<String>> execute(LoginProvider request) async {
    return await _authService.loginWithOAuth(request);
  }
}
