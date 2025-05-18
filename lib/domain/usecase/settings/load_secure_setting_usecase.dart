import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadSecureSettingsUseCase extends UseCase<String, Future<dynamic>> {
  LoadSecureSettingsUseCase(@Named("secureStorage") this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<dynamic> execute(String key) async {
    return await _settingsRepository.loadSetting(key);
  }
}
