import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/notification/provider/notification_data_provider.dart';
import 'package:grimity/presentation/notification/view/notification_body_view.dart';
import 'package:grimity/presentation/notification/view/notification_empty_view.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key, required this.notificationAppBar});

  final PreferredSizeWidget notificationAppBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationAsync = ref.watch(notificationDataProvider);

    return Scaffold(
      appBar: notificationAppBar,
      body: notificationAsync.when(
        data:
            (notifications) =>
                notifications.isEmpty ? NotificationEmptyView() : NotificationBodyView(notifications: notifications),
        error: (error, stackTrace) {
          /// TODO Error 표시
          return Text('error');
        },
        loading: () => GrimityCircularProgressIndicator(),
      ),
    );
  }
}
