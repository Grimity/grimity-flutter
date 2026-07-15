import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/theme_type.enum.dart';
import 'package:grimity/app/setting/setting_binding.dart';

class SettingThemeView extends StatelessWidget {
  const SettingThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    final setting = SettingBinding.theme;

    return ListenableBuilder(
      listenable: setting,
      builder: (context, child) {
        final isDevice = setting.getValue() == ThemeType.device;
        final isLight = setting.getValue() == ThemeType.light;
        final isDark = setting.getValue() == ThemeType.dark;

        return ListView(
          children: [
            GdsListItem.textLarge(
              text: '시스템 설정 모드',
              state: isDevice ? GdsListItemState.pressed : GdsListItemState.enabled,
              isNegative: false,
              onTap: () {
                if (!isDevice) setting.setValue(ThemeType.device);
              },
            ),
            GdsListItem.textLarge(
              text: '밝은 모드',
              state: isLight ? GdsListItemState.pressed : GdsListItemState.enabled,
              isNegative: false,
              onTap: () {
                if (!isLight) setting.setValue(ThemeType.light);
              },
            ),
            GdsListItem.textLarge(
              text: '어두운 모드',
              state: isDark ? GdsListItemState.pressed : GdsListItemState.enabled,
              isNegative: false,
              onTap: () {
                if (!isDark) setting.setValue(ThemeType.dark);
              },
            ),
          ],
        );
      },
    );
  }
}
