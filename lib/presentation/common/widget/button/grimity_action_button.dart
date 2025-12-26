import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_user_image.dart';

/// Action 에서 사용 되는 버튼
class GrimityActionButton extends StatelessWidget {
  const GrimityActionButton._({required this.child, required this.onTap, this.showBadge = false});

  final Widget child;
  final VoidCallback onTap;
  final bool showBadge;

  /// Search Action Button
  factory GrimityActionButton.search(BuildContext context) => GrimityActionButton._(
    onTap: () => SearchRoute().push(context),
    child: Assets.icons.common.search.svg(width: 24, height: 24),
  );

  /// User Action Button
  factory GrimityActionButton.user(BuildContext context) {
    return GrimityActionButton._(
      onTap: () => Scaffold.of(context).openEndDrawer(),
      child: Consumer(
        builder: (context, ref, child) {
          final userImageUrl = ref.watch(userAuthProvider)?.image;

          return (userImageUrl != null)
              ? GrimityUserImage(
                imageUrl: userImageUrl,
                size: 24,
              )
              : SvgPicture.asset(Assets.icons.icon.defaultProfile.path, width: 24, height: 24);
        },
      ),
    );
  }

  /// Storage Action Button
  factory GrimityActionButton.storage(BuildContext context) => GrimityActionButton._(
    onTap: () => StorageRoute().push(context),
    child: Assets.icons.icon.storage.svg(width: 24, height: 24),
  );

  /// Storage Action Button
  factory GrimityActionButton.setting(BuildContext context) => GrimityActionButton._(
    onTap: () => SettingRoute().push(context),
    child: Assets.icons.icon.setting.svg(width: 24, height: 24),
  );

  /// Notification Action Button
  factory GrimityActionButton.notification(BuildContext context, {required bool hasNotification}) =>
      GrimityActionButton._(
        onTap: () => NotificationRoute().push(context),
        showBadge: hasNotification,
        child: Assets.icons.common.notification.svg(width: 24, height: 24),
      );

  @override
  Widget build(BuildContext context) {
    if (!showBadge) {
      return GrimityGesture(onTap: onTap, child: child);
    }

    return GrimityGesture(
      onTap: onTap,
      child: Stack(
        children: [
          child,
          Positioned(
            right: 2,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: AppColor.main, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}
