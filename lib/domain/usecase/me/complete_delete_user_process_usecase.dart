import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/domain/usecase/settings_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class CompleteDeleteUserProcessUseCase extends UseCase<LoginProvider, void> {
  CompleteDeleteUserProcessUseCase();

  @override
  Future<void> execute(LoginProvider provider) async {
    await deleteUserUseCase.execute();
    await clearSecureSettingsUseCase.execute();
    await logoutWithOAuthUseCase.execute(provider);
  }
}
