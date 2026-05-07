import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;
    final hasNotification = ref.watch(
      userAuthProvider.select((user) => user?.hasNotification ?? false),
    );
    final userImage = ref.watch(
      userAuthProvider.select((user) => user?.image),
    );
    Widget notificationAction = GdsGesture(
      onTap: () => NotificationRoute().push(context),
      child: GdsIcon.bellOutline.build(color: colors.icon.grayBold, width: 24, height: 24),
    );
    if (hasNotification) {
      notificationAction = Stack(
        clipBehavior: Clip.none,
        children: [
          notificationAction,
          Positioned(
            right: 2,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: colors.status.notification, shape: BoxShape.circle),
            ),
          ),
        ],
      );
    }
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      centerTitle: false,
      title: Assets.icons.icon.logo.svg(width: 90, height: 27),
      actions: [
        GdsGesture(
          onTap: () => SearchRoute().push(context),
          child: GdsIcon.magnifierOutline.build(color: colors.icon.grayBold, width: 24, height: 24),
        ),
        const SizedBox(width: GdsSpacing.spacing20),
        notificationAction,
        const SizedBox(width: GdsSpacing.spacing20),
        GdsGesture(
          onTap: () => Scaffold.of(context).openEndDrawer(),
          child: GdsPersonAvatar(
            size: GdsAvatarSize.xs,
            imageUrl: userImage,
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: GdsColors.gray30),
      ),
    );
  }
}
