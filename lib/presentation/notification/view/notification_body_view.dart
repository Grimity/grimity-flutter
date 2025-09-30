import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/notification/provider/notification_data_provider.dart';
import 'package:grimity/domain/entity/notification.dart';
import 'package:grimity/presentation/notification/widget/notification_action_button.dart';
import 'package:grimity/presentation/notification/widget/notification_widget.dart';

class NotificationBodyView extends ConsumerWidget {
  const NotificationBodyView({super.key, required this.notifications});

  final List<Notification> notifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(notificationDataProvider.notifier);

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
                  icon: Assets.icons.common.view,
                ),
                Gap(8),
                VerticalDivider(color: AppColor.gray300, width: 1,),
                Gap(8),
                NotificationActionButton(
                  title: '전체 삭제',
                  onTap: () => notifier.deleteAllNotification(),
                  icon: Assets.icons.common.delete,
                ),
              ],
            ),
          )
        ),
        SliverList.separated(
          itemBuilder: (context, index) {
            final notification = notifications[index];

            return NotificationWidget(notification: notification);
          },
          separatorBuilder: (context, index) => Divider(height: 1, color: AppColor.gray300),
          itemCount: notifications.length,
        ),
      ],
    );
  }
}

