import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/domain/usecase/settings_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveTokenUseCase extends NoParamNoResultUseCase {
  RemoveTokenUseCase();

  @override
  Future<void> execute() async {
    await removeSecureSettingsUseCase.execute(AppConst.accessTokenKey);
    await removeSecureSettingsUseCase.execute(AppConst.refreshTokenKey);
  }
}
