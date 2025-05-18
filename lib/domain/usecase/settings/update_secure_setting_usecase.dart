import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/settings_repository.dart';
import 'package:grimity/domain/usecase/settings_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateSecureSettingsUseCase extends UseCase<UpdateSettingParam, Future<void>> {
  UpdateSecureSettingsUseCase(@Named("secureStorage") this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<void> execute(UpdateSettingParam param) async {
    return await _settingsRepository.updateSetting(param.key, param.value);
  }
}
