import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab.dart';
import 'package:grimity/presentation/follow/enum/follow_enum_tab_type.dart';

class FollowTab extends ConsumerWidget {
  const FollowTab({super.key, required this.type, required this.currentIndex});

  final FollowTabType type;
  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAuthProvider);
    final count = type == FollowTabType.follower ? user?.followerCount : user?.followingCount;

    return GrimityTab.large(
      text: type.title,
      count: count ?? 0,
      tabStatus: currentIndex == type.index ? GrimityTabStatus.on : GrimityTabStatus.off,
    );
  }
}
