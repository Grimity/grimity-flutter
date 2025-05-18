import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/domain/usecase/settings_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadTokenUseCase extends NoParamUseCase<Token?> {
  LoadTokenUseCase();

  @override
  Future<Token?> execute() async {
    final accessToken = await loadSecureSettingsUseCase.execute(AppConst.accessTokenKey);
    final refreshToken = await loadSecureSettingsUseCase.execute(AppConst.refreshTokenKey);

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return Token(accessToken: accessToken, refreshToken: refreshToken);
  }
}
