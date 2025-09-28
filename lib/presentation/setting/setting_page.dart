import 'package:flutter/material.dart';
import 'package:grimity/presentation/setting/setting_view.dart';
import 'package:grimity/presentation/setting/view/setting_body_view.dart';
import 'package:grimity/presentation/setting/widget/setting_app_bar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingView(settingAppbar: SettingAppBar(), settingBodyView: SettingBodyView());
  }
}
