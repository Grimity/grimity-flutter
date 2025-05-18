import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutWithOAuthUseCase extends UseCase<LoginProvider, void> {
  LogoutWithOAuthUseCase(this._authRepository);

  final AuthRepository _authRepository;
  @override
  Future<void> execute(LoginProvider provider) async {
    await _authRepository.logoutWithOAuth(provider);
  }
}
