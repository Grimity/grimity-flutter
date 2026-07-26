import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/setting/page/setting_notification_page.dart';
import 'package:grimity/presentation/setting/view/setting_notification_view.dart';

class NotificationAppBar extends StatelessWidget {
  const NotificationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsTopNavigation.iconButton(
      title: '알림',
      onBack: () => context.pop(),
      icons: const [GdsIcon.settings],
      onIconTap: [
        () {
          final route = SettingRoute(
            $extra: {
              'initialPage': SettingNotificationPage(),
              'initialView': SettingNotificationView(),
            },
          );

          route.push(context);
        },
      ],
    );
  }
}
