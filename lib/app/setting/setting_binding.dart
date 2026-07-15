import 'package:flutter/widgets.dart';
import 'package:grimity/app/setting/theme_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingBinding {
  const SettingBinding._();

  static Listenable get listenable => Listenable.merge([theme]);

  static late final SharedPreferences prefs;
  static late final ThemeSetting theme;

  static Future<void> setup() async {
    prefs = await SharedPreferences.getInstance();
    theme = ThemeSetting();
  }
}
