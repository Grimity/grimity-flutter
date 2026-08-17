import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/pref_settings_service.dart';
import 'package:grimity/domain/usecase/settings_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdatePrefSettingsUseCase extends UseCase<UpdateSettingParam, Future<void>> {
  UpdatePrefSettingsUseCase(@Named("sharedPref") this._settingsService);

  final PrefSettingsService _settingsService;

  @override
  Future<void> execute(UpdateSettingParam param) async {
    return await _settingsService.updateSetting(param.key, param.value);
  }
}
