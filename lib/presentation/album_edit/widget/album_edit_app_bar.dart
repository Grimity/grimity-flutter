import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

class AlbumEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AlbumEditAppBar({super.key});

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
      title: Text('앨범 편집', style: AppTypeface.subTitle3),
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => AppTheme.kToolbarHeight;
}
