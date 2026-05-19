import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
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
    final colors = context.gdsColors;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(GdsSpacing.spacing16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NotificationActionButton(
                  title: '전체 읽음',
                  onTap: () => notifier.markAllNotificationAsRead(),
                  icon: GdsIcon.eyeOn,
                ),
                const Gap(GdsSpacing.spacing8),
                VerticalDivider(color: colors.border.graySubtler, width: 1),
                const Gap(GdsSpacing.spacing8),
                NotificationActionButton(
                  title: '전체 삭제',
                  onTap: () => notifier.deleteAllNotification(),
                  icon: GdsIcon.trash,
                ),
              ],
            ),
          ),
        ),
        SliverList.separated(
          itemBuilder: (context, index) {
            final notification = notifications[index];

            return NotificationWidget(notification: notification);
          },
          separatorBuilder: (context, index) => Divider(height: 1, color: colors.border.graySubtler),
          itemCount: notifications.length,
        ),
      ],
    );
  }
}
