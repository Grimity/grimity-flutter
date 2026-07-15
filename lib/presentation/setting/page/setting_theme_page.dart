import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/setting/view/setting_theme_view.dart';
import 'package:grimity/presentation/setting/widget/setting_app_bar.dart';

class SettingThemePage extends StatelessWidget {
  const SettingThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: SettingAppBar(title: '화면 테마'),
      body: SettingThemeView(),
    );
  }
}
