import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab_bar.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';
import 'package:grimity/presentation/profile/provider/profile_view_type_argument_provider.dart';

class ProfileTabBar extends ConsumerWidget {
  const ProfileTabBar({super.key, required this.user, required this.tabController});

  final User user;
  final TabController tabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = ref.watch(profileViewTypeArgumentProvider);

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
}
