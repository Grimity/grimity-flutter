import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/pref_settings_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearPrefSettingsUseCase extends NoParamNoResultUseCase {
  ClearPrefSettingsUseCase(@Named("sharedPref") this._settingsService);

  final PrefSettingsService _settingsService;

  @override
  Future<void> execute() async {
    return await _settingsService.clearSetting();
  }
}
