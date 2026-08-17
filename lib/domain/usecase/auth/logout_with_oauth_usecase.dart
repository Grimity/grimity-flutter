import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/data/service/auth_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutWithOAuthUseCase extends UseCase<LoginProvider, void> {
  LogoutWithOAuthUseCase(this._authService);

  final AuthService _authService;

  @override
  Future<void> execute(LoginProvider provider) async {
    await _authService.logoutWithOAuth(provider);
  }
}
