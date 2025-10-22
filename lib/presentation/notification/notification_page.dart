import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/entity/notification.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/notification/notification_view.dart';
import 'package:grimity/presentation/notification/provider/notification_data_provider.dart';
import 'package:grimity/presentation/notification/view/notification_body_view.dart';
import 'package:grimity/presentation/notification/widget/notification_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationAsync = ref.watch(notificationDataProvider);

    return NotificationView(
      notificationAppBar: NotificationAppBar(),
      notificationBody: notificationAsync.when(
        data:
            (notifications) =>
                notifications.isEmpty
                    ? GrimityStateView.resultNull(
                      title: '새로운 알림이 없어요',
                      subTitle: '내 글의 댓글와 좋아요, 다른 작가의 활동 등\n새로운 소식을 알려드려요',
                    )
                    : NotificationBodyView(notifications: notifications),
        loading: () => Skeletonizer(child: NotificationBodyView(notifications: Notification.emptyList)),
        error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(notificationDataProvider)),
      ),
    );
  }
}
