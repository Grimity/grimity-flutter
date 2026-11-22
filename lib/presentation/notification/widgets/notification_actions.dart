// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';

/// 알림 전체 읽음과 삭제 버튼을 표시하는 위젯.
class NotificationActions extends StatelessWidget {
  const new({
    super.key,
    required this.service,
  });

  final GetNotifications service;

  @override
  Widget build(BuildContext context) {
    final hasData = service.maybeData?.isNotEmpty ?? false;

    return Padding(
      padding: 12.vertical + 16.horizontal,
      child: Row(
        mainAxisAlignment: .end,
        spacing: 8,
        children: [
          // 모든 알림을 읽음 상태로 변경하는 버튼 표시
          GdsButton.text(
            size: .md,
            type: .borderless,
            variant: .assistive,
            enabled: hasData,
            label: '전체 읽음',
            trailingIcon: .eye,
            onTap: () async {
              await PutNotifications().request();
              await Future.wait([
                service.refresh(),
                AppUser.refresh(),
              ]);
            },
          ),

          GdsDivider(
            variant: .primary,
            vertical: true,
            extent: 24,
          ),

          // 모든 알림을 삭제하는 버튼 표시
          GdsButton.text(
            size: .md,
            type: .borderless,
            variant: .assistive,
            enabled: hasData,
            label: '전체 삭제',
            trailingIcon: .trashBinTrash,
            onTap: () async {
              await DeleteNotifications().request();
              await Future.wait([
                service.refresh(),
                AppUser.refresh(),
              ]);
            },
          ),
        ],
      ),
    );
  }
}
