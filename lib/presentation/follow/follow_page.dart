import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/follow/enum/follow_enum_tab_type.dart';
import 'package:grimity/presentation/follow/view/follow_view.dart';
import 'package:grimity/presentation/follow/view/follow_followers_view.dart';
import 'package:grimity/presentation/follow/view/follow_following_view.dart';
import 'package:grimity/presentation/follow/widget/follow_app_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FollowPage extends HookConsumerWidget {
  const FollowPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: FollowTabType.values.length);

    return FollowView(
      followAppBar: FollowAppBar(tabController: tabController),
      followBody: TabBarView(controller: tabController, children: [FollowersView(), FollowingView()]),
    );
  }
}
