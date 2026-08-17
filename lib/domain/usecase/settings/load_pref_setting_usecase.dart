import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/pref_settings_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadPrefSettingsUseCase extends UseCase<String, Future<dynamic>> {
  LoadPrefSettingsUseCase(@Named("sharedPref") this._settingsService);

  final PrefSettingsService _settingsService;

  @override
  Future<dynamic> execute(String key) async {
    return await _settingsService.loadSetting(key);
  }
}
