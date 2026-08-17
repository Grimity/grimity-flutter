import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/secure_settings_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadSecureSettingsUseCase extends UseCase<String, Future<dynamic>> {
  LoadSecureSettingsUseCase(@Named("secureStorage") this._settingsService);

  final SecureSettingsService _settingsService;

  @override
  Future<dynamic> execute(String key) async {
    return await _settingsService.loadSetting(key);
  }
}
