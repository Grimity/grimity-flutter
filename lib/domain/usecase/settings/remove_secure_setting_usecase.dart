import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveSecureSettingsUseCase extends UseCase<String, Future<void>> {
  RemoveSecureSettingsUseCase(@Named("secureStorage") this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<void> execute(String key) async {
    return await _settingsRepository.removeSetting(key);
  }
}
