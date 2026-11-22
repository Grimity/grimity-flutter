// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/extensions/model/notification_response.dart';
import 'package:grimity/presentation/notification/widgets/notification_actions.dart';
import 'package:grimity/presentation/notification/widgets/notification_app_bar.dart';
import 'package:pervice/pervice.dart';
import 'package:url_launcher/url_launcher.dart';

/// 알림 목록을 조회하고 전체 읽음과 삭제 기능을 제공하는 페이지.
class NotificationPage extends StatelessWidget {
  const new({super.key});

  /// 알림 목록을 불러오는 동안 표시할 임시 데이터.
  static final placeholder = List.generate(5, (_) {
    return NotificationResponse(
      id: '',
      createdAt: .now(),
      isRead: false,
      link: '',
      image: null,
      message: 'Placeholder',
    );
  });

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(GetNotifications.new);

    return GdsScaffold(
      appBar: const NotificationAppBar(),
      body: Column(
        children: [
          // 액션 버튼 표시
          NotificationActions(service: service),

          // 알림 목록 표시
          Expanded(
            child: service.builder(
              placeholder: placeholder,
              builder: (notifs) {
                // 알림이 아예 없을 경우.
                if (notifs.isEmpty) {
                  return Center(
                    child: GdsEmptyState(
                      illust: .alarm,
                      title: '새로운 알림이 없어요',
                      description:
                          '내 글의 댓글와 좋아요, 다른 작가의 활동 등\n'
                          '새로운 소식을 알려드려요',
                    ),
                  );
                }

                return ListView.builder(
                  padding: 16.bottom + 16.horizontal,
                  itemCount: notifs.length,
                  itemBuilder: (context, index) {
                    final notif = notifs[index];

                    return GdsUserItem.notification(
                      type: notif.type,
                      content: notif.message,
                      createdAt: notif.createdAt,
                      read: notif.isRead,
                      onTap: () async {
                        // 알림에 연결된 링크 열기.
                        launchUrl(Uri.parse(notif.link), mode: .externalApplication);

                        // 읽지 않은 알림만 읽음 처리.
                        if (!notif.isRead) {
                          await PutNotificationsById(id: notif.id).request();
                          await Future.wait([
                            service.refresh(),
                            AppUser.refresh(),
                          ]);
                        }
                      },
                      onClose: () async {
                        await DeleteNotificationsById(id: notif.id).request();
                        await Future.wait([
                          service.refresh(),
                          AppUser.refresh(),
                        ]);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
