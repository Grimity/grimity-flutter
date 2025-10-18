import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/app/config/app_color.dart';

/// Action 에서 사용 되는 버튼
class GrimityActionButton extends StatelessWidget {
  const GrimityActionButton._({required this.icon, required this.onTap, this.showBadge = false});

  final SvgGenImage icon;
  final VoidCallback onTap;
  final bool showBadge;

  /// Search Action Button
  factory GrimityActionButton.search(BuildContext context) =>
      GrimityActionButton._(onTap: () => SearchRoute().push(context), icon: Assets.icons.common.search);

  /// Menu Action Button
  factory GrimityActionButton.menu(BuildContext context) =>
      GrimityActionButton._(onTap: () => Scaffold.of(context).openEndDrawer(), icon: Assets.icons.common.menu);

  /// Storage Action Button
  factory GrimityActionButton.storage(BuildContext context) =>
      GrimityActionButton._(onTap: () => StorageRoute().push(context), icon: Assets.icons.common.storage);

  /// Storage Action Button
  factory GrimityActionButton.setting(BuildContext context) =>
      GrimityActionButton._(onTap: () => SettingRoute().push(context), icon: Assets.icons.common.setting);

  /// Notification Action Button
  factory GrimityActionButton.notification({required VoidCallback onTap, bool showBadge = false}) =>
      GrimityActionButton._(onTap: onTap, icon: Assets.icons.common.notification, showBadge: showBadge);

  @override
  Widget build(BuildContext context) {
    if (!showBadge) {
      return GestureDetector(onTap: onTap, child: icon.svg(width: 24.w, height: 24.w));
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          icon.svg(width: 24.w, height: 24.w),
          Positioned(
            right: 2,
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(color: AppColor.main, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}
