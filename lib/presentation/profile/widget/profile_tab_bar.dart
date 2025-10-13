import 'package:flutter/material.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab_bar.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';

class ProfileTabBar extends SliverPersistentHeaderDelegate {
  const ProfileTabBar({required this.user, required this.tabController, required this.viewType});

  final User user;
  final TabController tabController;
  final ProfileViewType viewType;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GrimityTabBar.medium(
      tabController: tabController,
      buildTabs:
          (currentIndex) => [
            GrimityTab.medium(
              text: '그림',
              count: user.feedCount ?? 0,
              tabStatus: currentIndex == 0 ? GrimityTabStatus.on : GrimityTabStatus.off,
            ),

            if (viewType == ProfileViewType.mine)
              GrimityTab.medium(
                text: '글',
                count: user.postCount ?? 0,
                tabStatus: currentIndex == 1 ? GrimityTabStatus.on : GrimityTabStatus.off,
              ),
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
