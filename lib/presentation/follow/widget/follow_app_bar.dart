import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/follow/widget/follow_tab_bar.dart';

class FollowAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const FollowAppBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('친구 목록', style: AppTypeface.subTitle3.copyWith(color: AppColor.primary4)),
      titleSpacing: 0,
      bottom: FollowTabBar(tabController: tabController),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppTheme.kToolbarHeight.height + kTextTabBarHeight);
}
