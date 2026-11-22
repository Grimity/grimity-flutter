// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/settings/views/settings_notification.dart';

/// 알림 제목과 설정 버튼을 표시하는 앱바 위젯.
class NotificationAppBar extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsTopNavigation.iconButton(
      onBack: context.pop,
      title: '알림',
      actions: [
        .new(
          icon: .settings,
          onTap: () {
            // 알림 설정 페이지로 이동.
            context.push(const SettingsNotification().buildView(context));
          },
        ),
      ],
    );
  }
}
