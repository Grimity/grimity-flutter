import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/settings/clear_pref_setting_usecase.dart';
import 'package:grimity/domain/usecase/settings/clear_secure_setting_usecase.dart';
import 'package:grimity/domain/usecase/settings/load_pref_setting_usecase.dart';
import 'package:grimity/domain/usecase/settings/load_secure_setting_usecase.dart';
import 'package:grimity/domain/usecase/settings/remove_pref_setting_usecase.dart';
import 'package:grimity/domain/usecase/settings/remove_secure_setting_usecase.dart';
import 'package:grimity/domain/usecase/settings/update_pref_setting_usecase.dart';
import 'package:grimity/domain/usecase/settings/update_secure_setting_usecase.dart';

final clearPrefSettingsUseCase = getIt<ClearPrefSettingsUseCase>();
final clearSecureSettingsUseCase = getIt<ClearSecureSettingsUseCase>();

final loadPrefSettingsUseCase = getIt<LoadPrefSettingsUseCase>();
final loadSecureSettingsUseCase = getIt<LoadSecureSettingsUseCase>();

final removePrefSettingsUseCase = getIt<RemovePrefSettingsUseCase>();
final removeSecureSettingsUseCase = getIt<RemoveSecureSettingsUseCase>();

final updatePrefSettingsUseCase = getIt<UpdatePrefSettingsUseCase>();
final updateSecureSettingsUseCase = getIt<UpdateSecureSettingsUseCase>();

class UpdateSettingParam {
  final String key;
  final dynamic value;

  UpdateSettingParam({required this.key, required this.value});
}
