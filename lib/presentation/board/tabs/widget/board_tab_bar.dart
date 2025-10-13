import 'package:flutter/material.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab_bar.dart';

class BoardTabBar extends SliverPersistentHeaderDelegate {
  const BoardTabBar({required this.tabController, required this.tabList});

  final TabController tabController;
  final List<PostType> tabList;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GrimityTabBar.medium(
      tabController: tabController,
      buildTabs: (currentIndex) {
        return tabList
            .map(
              (type) => GrimityTab.medium(
                text: type.typeName,
                tabStatus: currentIndex == tabList.indexOf(type) ? GrimityTabStatus.on : GrimityTabStatus.off,
              ),
            )
            .toList();
      },
    );
  }

  @override
  double get maxExtent => GrimityTabBarSize.medium.height;

  @override
  double get minExtent => GrimityTabBarSize.medium.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
