import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadPrefSettingsUseCase extends UseCase<String, Future<dynamic>> {
  LoadPrefSettingsUseCase(@Named("sharedPref") this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<dynamic> execute(String key) async {
    return await _settingsRepository.loadSetting(key);
  }
}
