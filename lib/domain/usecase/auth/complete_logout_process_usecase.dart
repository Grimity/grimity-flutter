import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';
import 'package:grimity/domain/usecase/settings_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class CompleteLogoutProcessUseCase extends UseCase<LoginProvider, void> {
  CompleteLogoutProcessUseCase();

  @override
  Future<void> execute(LoginProvider provider) async {
    await clearSecureSettingsUseCase.execute();
    await logoutWithOAuthUseCase.execute(provider);
    await logoutUseCase.execute();
  }
}
