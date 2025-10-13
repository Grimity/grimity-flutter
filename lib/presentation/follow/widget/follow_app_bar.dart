import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab_bar.dart';
import 'package:grimity/presentation/follow/enum/follow_enum_tab_type.dart';
import 'package:grimity/presentation/follow/widget/follow_tab.dart';

class FollowAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const FollowAppBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('친구 목록', style: AppTypeface.subTitle3.copyWith(color: AppColor.primary4)),
      titleSpacing: 0,
      bottom: GrimityTabBar.large(
        tabController: tabController,
        buildTabs:
            (currentIndex) => FollowTabType.values.map((e) => FollowTab(type: e, currentIndex: currentIndex)).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppTheme.kToolbarHeight.height + GrimityTabBarSize.large.height);
}
