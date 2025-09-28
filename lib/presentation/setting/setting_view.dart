import 'package:flutter/material.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key, required this.settingAppbar, required this.settingBodyView});

  final PreferredSizeWidget settingAppbar;
  final Widget settingBodyView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: settingAppbar, body: settingBodyView);
  }
}
