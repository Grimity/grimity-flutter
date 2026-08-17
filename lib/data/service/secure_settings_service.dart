import 'package:grimity/data/data_source/local/settings_local_data_source.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
@Named("secureStorage")
class SecureSettingsService {
  final SettingsLocalDataSource dataSource;

  SecureSettingsService(@Named("secureStorage") this.dataSource);

  Future<void> clearSetting() async {
    return await dataSource.clearSetting();
  }

  Future<dynamic> loadSetting(String key) async {
    return await dataSource.loadSetting(key);
  }

  Future<void> removeSetting(String key) async {
    return await dataSource.removeSetting(key);
  }

  Future<void> updateSetting(String key, dynamic value) {
    return dataSource.updateSetting(key, value);
  }
}
