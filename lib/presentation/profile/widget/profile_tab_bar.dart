import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/user.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({
    super.key,
    required this.user,
    required this.tabController,
  });

  final User user;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    user.feedCount;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      child: ListenableBuilder(
        listenable: tabController,
        builder: (context, child) {
          return GdsTab(
            size: context.isMobile ? GdsTabSize.sm : GdsTabSize.md,
            index: tabController.index,
            items: [
              GdsTabItem(label: '그림', onTap: () => tabController.animateTo(0), badge: '${user.feedCount}'),
              GdsTabItem(label: '글', onTap: () => tabController.animateTo(1), badge: '${user.postCount}'),
            ],
          );
        },
      ),
    );
  }
}
