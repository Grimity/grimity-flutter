import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/domain/usecase/settings_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTokenUseCase extends UseCase<Token, void> {
  UpdateTokenUseCase();

  @override
  Future<void> execute(Token token) async {
    await updateSecureSettingsUseCase.execute(
      UpdateSettingParam(key: AppConst.accessTokenKey, value: token.accessToken),
    );
    await updateSecureSettingsUseCase.execute(
      UpdateSettingParam(key: AppConst.refreshTokenKey, value: token.refreshToken),
    );
  }
}
