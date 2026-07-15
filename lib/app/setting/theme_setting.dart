import 'package:grimity/app/enum/theme_type.enum.dart';
import 'package:grimity/app/setting/setting_with_enum.dart';

class ThemeSetting extends SettingWithEnum<ThemeType> {
  @override
  String get key => 'theme';

  @override
  ThemeType get initialValue => ThemeType.device;

  @override
  List<ThemeType> get values => ThemeType.values;
}
