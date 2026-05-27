import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/notification/provider/notification_data_provider.dart';
import 'package:grimity/domain/entity/notification.dart';
import 'package:grimity/presentation/notification/widget/notification_action_button.dart';
import 'package:grimity/presentation/notification/widget/notification_widget.dart';

class NotificationBodyView extends ConsumerWidget {
  const NotificationBodyView({super.key, required this.notifications, this.isEmpty = false});

  final List<Notification> notifications;
  final bool isEmpty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(notificationDataProvider.notifier);
    final colors = context.gdsColors;
    final listDividerColor = colors.border.graySubtle;
    final actionDividerColor = colors.border.graySubtle;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NotificationActionButton(
                  title: '전체 읽음',
                  onTap: () => notifier.markAllNotificationAsRead(),
                  icon: Assets.icons.icon.eye,
                ),
                Gap(8),
                Container(width: 1, height: 24, color: actionDividerColor),
                Gap(8),
                NotificationActionButton(
                  title: '전체 삭제',
                  onTap: () => notifier.deleteAllNotification(),
                  icon: Assets.icons.icon.trash,
                ),
              ],
            ),
          ),
        ),
        if (isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 72),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GdsIcon.alarmDark.build(width: 60, height: 60),
                  const Gap(16),
                  Text(
                    '새로운 알림이 없어요',
                    style: AppTypeface.subTitle1.copyWith(color: colors.text.grayBold),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(12),
                  Text(
                    '내 글의 댓글와 좋아요, 다른 작가의 활동 등\n새로운 소식을 알려드려요',
                    style: AppTypeface.label3.copyWith(color: colors.text.grayBold, height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          SliverList.separated(
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return NotificationWidget(notification: notification);
            },
            separatorBuilder: (context, index) => Divider(height: 1, color: listDividerColor),
            itemCount: notifications.length,
          ),
      ],
    );
  }
}
