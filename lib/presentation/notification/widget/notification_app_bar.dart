import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';

class NotificationAppBar extends StatelessWidget {
  const NotificationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsTopNavigation.iconButton(
      title: '알림',
      onBack: () => context.pop(),
      icons: const [GdsIcon.settings],
      onIconTap: [() => SettingRoute().push(context)],
    );
  }
}
