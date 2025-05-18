import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemovePrefSettingsUseCase extends UseCase<String, Future<void>> {
  RemovePrefSettingsUseCase(@Named("sharedPref") this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<void> execute(String key) async {
    return await _settingsRepository.removeSetting(key);
  }
}
