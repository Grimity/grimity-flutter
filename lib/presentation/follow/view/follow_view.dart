import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/follow/view/follow_following_user_view.dart';
import 'package:grimity/presentation/follow/view/follow_follower_user_view.dart';

class FollowView extends HookWidget {
  const FollowView({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return AppBarConnection(
      appBars: [
        AppBar(
          behavior: AbsoluteAppBarBehavior(),
          body: ListenableBuilder(
            listenable: tabController,
            builder: (context, child) {
              return Padding(
                padding:
                    context.isMobile
                        ? EdgeInsets.symmetric(horizontal: GdsSpacing.spacing16)
                        : EdgeInsets.only(
                          top: GdsSpacing.spacing8,
                          left: GdsSpacing.spacing20,
                          right: GdsSpacing.spacing20,
                        ),
                child: GdsTab(
                  size: context.isMobile ? GdsTabSize.sm : GdsTabSize.md,
                  controller: tabController,
                  items: [
                    GdsTabItem(label: '팔로잉', onTap: () => tabController.animateTo(0)),
                    GdsTabItem(label: '팔로워', onTap: () => tabController.animateTo(1)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
      child: TabBarView(
        controller: tabController,
        children: [FollowingUserView(), FollowerUserView()],
      ),
    );
  }
}
