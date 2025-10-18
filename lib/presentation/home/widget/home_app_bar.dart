import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/button/grimity_action_button.dart';
import 'package:grimity/presentation/notification/provider/notification_data_provider.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationAsync = ref.watch(notificationDataProvider);

    onNotificationTap() {
      // 홈 화면 진입시 데이터가 수신되서 알림 화면 진입시 데이터가 최신 데이터가 아닐 수 있음
      // 따라서 데이터 리프래시 처리하여 재수신 하게 함
      ref.invalidate(notificationDataProvider);
      NotificationRoute().push(context);
    }

    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      centerTitle: false,
      title: Assets.images.logo.svg(width: 90.w, height: 27.h),
      actions: [
        GrimityActionButton.search(context),
        Gap(20.w),
        notificationAsync.maybeWhen(
          data: (notifications) {
            final hasUnRead = notifications.where((n) => !n.isRead).isNotEmpty;

            return GrimityActionButton.notification(onTap: () => onNotificationTap(), showBadge: hasUnRead);
          },
          orElse: () => GrimityActionButton.notification(onTap: () => onNotificationTap()),
        ),
        Gap(20.w),
        GrimityActionButton.menu(context),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.gray300),
      ),
    );
  }
}
