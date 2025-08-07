import 'package:flutter/material.dart';
import 'package:grimity/presentation/following_feed/following_feed_view.dart';
import 'package:grimity/presentation/following_feed/view/following_feed_list_view.dart';
import 'package:grimity/presentation/following_feed/widget/following_feed_app_bar.dart';

class FollowingFeedPage extends StatelessWidget {
  const FollowingFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FollowingFeedView(
      followFeedAppbar: FollowingFeedAppBar(),
      followingFeedListView: FollowingFeedListView(),
    );
  }
}
