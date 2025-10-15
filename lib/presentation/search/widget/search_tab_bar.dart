import 'package:flutter/material.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab_bar.dart';

class SearchTabBar extends SliverPersistentHeaderDelegate {
  const SearchTabBar({required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GrimityTabBar.medium(
      tabController: tabController,
      buildTabs:
          (currentIndex) => [
            GrimityTab.medium(text: '그림', tabStatus: currentIndex == 0 ? GrimityTabStatus.on : GrimityTabStatus.off),
            GrimityTab.medium(text: '유저', tabStatus: currentIndex == 1 ? GrimityTabStatus.on : GrimityTabStatus.off),
            GrimityTab.medium(text: '자유게시판', tabStatus: currentIndex == 2 ? GrimityTabStatus.on : GrimityTabStatus.off),
          ],
    );
  }

  @override
  double get maxExtent => GrimityTabBarSize.medium.height;

  @override
  double get minExtent => GrimityTabBarSize.medium.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
