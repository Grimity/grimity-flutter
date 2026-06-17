import 'package:flutter/material.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_main_top_navigation.dart';
import 'package:grimity/presentation/following_feed/following_feed_view.dart';
import 'package:grimity/presentation/following_feed/view/following_feed_list_view.dart';
import 'package:grimity/presentation/following_feed/view/recommend_author_view.dart';

class FollowingFeedPage extends StatelessWidget {
  const FollowingFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FollowingFeedView(
      followFeedAppbar: GrimityMainTopNavigation(),
      followingFeedListView: FollowingFeedListView(),
      recommendAuthorView: RecommendAuthorListView(),
    );
  }
}
