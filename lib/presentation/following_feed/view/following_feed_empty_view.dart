import 'package:flutter/material.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/following_feed/view/recommend_author_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FollowingFeedEmptyView extends ConsumerWidget {
  const FollowingFeedEmptyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAuthProvider);

    return Column(
      children: [
        user?.followingCount == 0
            ? GrimityStateView.user(title: '아직 팔로우하는 작가가 없어요', subTitle: '관심 있는 작가를 팔로우하고\n새로운 작품 소식을 받아보세요.')
            : GrimityStateView.resultNull(title: '아직 올라온 그림이 없어요.', subTitle: '관심 있는 작가를 팔로우하고\n새로운 작품 소식을 받아보세요.'),
        FollowingFeedRecommendAuthorListView(),
      ],
    );
  }
}
