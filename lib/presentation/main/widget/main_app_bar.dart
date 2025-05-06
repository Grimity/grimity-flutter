import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/gen/assets.gen.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Assets.images.logo.svg(width: 90.w, height: 27.h),
      actions: [
        GestureDetector(onTap: () {}, child: Assets.icons.main.search.svg(width: 24.w, height: 24.w)),
        Gap(20.w),
        GestureDetector(onTap: () {}, child: Assets.icons.main.notification.svg(width: 24.w, height: 24.w)),
        Gap(20.w),
        GestureDetector(onTap: () {}, child: Assets.icons.main.menu.svg(width: 24.w, height: 24.w)),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.gray300),
      ),
    );
  }

  @override
  Size get preferredSize => AppTheme.kToolbarHeight;
}
