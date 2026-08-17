import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/secure_settings_service.dart';
import 'package:grimity/domain/usecase/settings_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateSecureSettingsUseCase extends UseCase<UpdateSettingParam, Future<void>> {
  UpdateSecureSettingsUseCase(@Named("secureStorage") this._settingsService);

  final SecureSettingsService _settingsService;

  @override
  Future<void> execute(UpdateSettingParam param) async {
    return await _settingsService.updateSetting(param.key, param.value);
  }
}
