import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/secure_settings_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearSecureSettingsUseCase extends NoParamNoResultUseCase {
  ClearSecureSettingsUseCase(@Named("secureStorage") this._settingsService);

  final SecureSettingsService _settingsService;

  @override
  Future<void> execute() async {
    return await _settingsService.clearSetting();
  }
}
