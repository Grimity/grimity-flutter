import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/notification.dart';
import 'package:grimity/presentation/notification/widget/notification_widget.dart';

class NotificationBodyView extends ConsumerWidget {
  const NotificationBodyView({super.key, required this.notifications});

  final List<Notification> notifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;

    return CustomScrollView(
      slivers: [
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
