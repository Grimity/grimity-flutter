import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/notification/provider/notification_data_provider.dart';
import 'package:grimity/domain/entity/notification.dart';
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
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: GestureDetector(
              onTap: () => notifier.deleteAllNotification(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('전체 삭제', style: AppTypeface.caption2.copyWith(color: AppColor.gray700)),
                  Gap(6),
                  Assets.icons.common.delete.svg(width: 16, height: 16),
                ],
              ),
            ),
          ),
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
