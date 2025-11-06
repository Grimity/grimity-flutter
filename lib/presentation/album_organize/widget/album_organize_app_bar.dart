import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

class AlbumOrganizeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AlbumOrganizeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: AppTheme.kToolbarHeight.height,
      leading: Center(
        child: GrimityGesture(
          onTap: () => context.pop(),
          child: Assets.icons.common.close.svg(width: 24.w, height: 24.w),
        ),
      ),
      title: Text('그림 정리', style: AppTypeface.subTitle3),
      titleSpacing: 0,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.gray300),
      ),
    );
  }

  @override
  Size get preferredSize => AppTheme.kToolbarHeight;
}
