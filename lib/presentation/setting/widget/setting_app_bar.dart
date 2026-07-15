import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';

class SettingAppBar extends StatelessWidget {
  const SettingAppBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return GdsTopNavigation.iconButton(
      title: title,
      icons: [],
      onIconTap: [],
      showIcons: false,
      onBack: context.pop,
    );
  }
}
