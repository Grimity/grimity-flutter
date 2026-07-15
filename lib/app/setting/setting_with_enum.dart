import 'package:collection/collection.dart';
import 'package:grimity/app/setting/setting.dart';
import 'package:grimity/app/setting/setting_binding.dart';

abstract class SettingWithEnum<T extends Enum> extends Setting<T> {
  T get initialValue;
  List<T> get values;

  @override
  T getValue() {
    final value = SettingBinding.prefs.getString(key);
    return values.firstWhereOrNull((e) => e.name == value) ?? initialValue;
  }

  @override
  Future<void> setValue(T newValue) async {
    await SettingBinding.prefs.setString(key, newValue.name);
    notifyListeners();
  }
}
