import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearSecureSettingsUseCase extends NoParamNoResultUseCase {
  ClearSecureSettingsUseCase(@Named("secureStorage") this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<void> execute() async {
    return await _settingsRepository.clearSetting();
  }
}
