import 'package:grimity/data/data_source/local/settings_local_data_source.dart';
import 'package:grimity/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SettingsRepository)
@Named("sharedPref")
class PrefSettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource dataSource;

  PrefSettingsRepositoryImpl(@Named("sharedPref") this.dataSource);

  @override
  Future<void> clearSetting() async {
    return await dataSource.clearSetting();
  }

  @override
  Future<dynamic> loadSetting(String key) async {
    return await dataSource.loadSetting(key);
  }

  @override
  Future<void> removeSetting(String key) async {
    return dataSource.removeSetting(key);
  }

  @override
  Future<void> updateSetting(String key, dynamic value) {
    return dataSource.updateSetting(key, value);
  }
}
