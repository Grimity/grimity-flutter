import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/follow/enum/follow_enum_tab_type.dart';
import 'package:grimity/presentation/follow/widget/follow_tab_widget.dart';

class FollowTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const FollowTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: AppColor.gray700,
      unselectedLabelColor: AppColor.gray600,
      labelStyle: AppTypeface.subTitle4,
      unselectedLabelStyle: AppTypeface.body1,
      indicatorColor: AppColor.gray800,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: AppColor.gray300,
      tabs: FollowTabType.values.map((e) => FollowTabWidget(type: e)).toList(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight);
}
