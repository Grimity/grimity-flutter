import 'package:flutter/material.dart';
import 'package:grimity/presentation/home/home_view.dart';
import 'package:grimity/presentation/home/view/home_latest_feed_view.dart';
import 'package:grimity/presentation/home/view/home_latest_post_view.dart';
import 'package:grimity/presentation/home/view/home_notice_view.dart';
import 'package:grimity/presentation/home/view/home_feed_ranking_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeView(
      noticeView: const HomeNoticeView(),
      feedRankingView: const HomeFeedRankingView(),
      latestPostView: const HomeLatestPostView(),
      latestFeedView: const HomeLatestFeedView(),
    );
  }
}
