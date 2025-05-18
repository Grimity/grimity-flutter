abstract class SettingsRepository {
  Future<void> clearSetting();
  Future<dynamic> loadSetting(String key);
  Future<void> removeSetting(String key);
  Future<void> updateSetting(String key, dynamic value);
}
