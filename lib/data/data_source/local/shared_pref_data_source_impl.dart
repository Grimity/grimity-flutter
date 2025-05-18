import 'package:grimity/data/data_source/local/settings_local_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class SharedPreferencesModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

@Injectable(as: SettingsLocalDataSource)
@Named("sharedPref")
@singleton
class SharedPrefDataSourceImpl implements SettingsLocalDataSource {
  SharedPrefDataSourceImpl(this.prefs);

  final SharedPreferences prefs;

  @override
  Future<void> clearSetting() async {
    await prefs.clear();
  }

  @override
  Future<dynamic> loadSetting(String key) async {
    return prefs.get(key);
  }

  @override
  Future<void> removeSetting(String key) async {
    await prefs.remove(key);
  }

  @override
  Future<void> updateSetting(String key, dynamic value) async {
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else {
      throw UnimplementedError('Unsupported type for Shared Preferences');
    }
  }
}
