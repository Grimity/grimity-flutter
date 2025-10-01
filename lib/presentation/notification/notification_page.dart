import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/notification/notification_view.dart';
import 'package:grimity/presentation/notification/provider/notification_data_provider.dart';
import 'package:grimity/presentation/notification/view/notification_body_view.dart';
import 'package:grimity/presentation/notification/view/notification_empty_view.dart';
import 'package:grimity/presentation/notification/widget/notification_app_bar.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationAsync = ref.watch(notificationDataProvider);

    return NotificationView(
      notificationAppBar: NotificationAppBar(),
      notificationBody: notificationAsync.maybeWhen(
        data:
            (notifications) =>
                notifications.isEmpty ? NotificationEmptyView() : NotificationBodyView(notifications: notifications),
        orElse: () => GrimityCircularProgressIndicator(),
      ),
    );
  }
}
