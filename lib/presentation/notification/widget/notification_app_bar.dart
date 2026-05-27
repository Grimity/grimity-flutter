import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

class NotificationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NotificationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return AppBar(
      backgroundColor: colors.bg.primary,
      surfaceTintColor: colors.bg.primary,
      foregroundColor: colors.icon.grayBold,
      iconTheme: IconThemeData(color: colors.icon.grayBold),
      toolbarHeight: AppTheme.kToolbarHeight.height,
      leading: Center(
        child: GrimityGesture(
          onTap: () => Navigator.of(context).maybePop(),
          child: Assets.icons.icon.chevronLeftThick.svg(
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(colors.icon.grayBold, BlendMode.srcIn),
          ),
        ),
      ),
      title: Text('알림', style: AppTypeface.subTitle3.copyWith(color: colors.text.grayBold)),
      titleSpacing: 0,
      actions: [
        GrimityGesture(
          onTap: () => SettingRoute().push(context),
          child: Assets.icons.icon.setting.svg(
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(colors.icon.grayBold, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => AppTheme.kToolbarHeight;
}
