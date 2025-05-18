import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grimity/data/data_source/local/settings_local_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SettingsLocalDataSource)
@Named("secureStorage")
@singleton
class SecureStorageDataSourceImpl implements SettingsLocalDataSource {
  SecureStorageDataSourceImpl();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final iOptions = const IOSOptions(accessibility: KeychainAccessibility.first_unlock, synchronizable: true);

  @override
  Future<void> clearSetting() async {
    await secureStorage.deleteAll(iOptions: iOptions);
  }

  @override
  Future<dynamic> loadSetting(String key) async {
    return await secureStorage.read(key: key, iOptions: iOptions);
  }

  @override
  Future<void> removeSetting(String key) async {
    return await secureStorage.delete(key: key, iOptions: iOptions);
  }

  @override
  Future<void> updateSetting(String key, dynamic value) async {
    if (value.runtimeType != String) throw UnimplementedError("Unsupported type for Secure Storage");

    await secureStorage.write(key: key, value: value, iOptions: iOptions);
  }
}
