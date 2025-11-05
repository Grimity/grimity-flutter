import 'package:flutter/material.dart';
import 'package:grimity/presentation/home/home_view.dart';
import 'package:grimity/presentation/home/view/home_latest_feed_view.dart';
import 'package:grimity/presentation/home/view/home_latest_post_view.dart';
import 'package:grimity/presentation/home/view/home_notice_view.dart';
import 'package:grimity/presentation/home/view/home_feed_ranking_view.dart';
import 'package:grimity/presentation/home/widget/home_app_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeView(
      homeAppBar: const HomeAppBar(),
      noticeView: const HomeNoticeView(),
      feedRankingView: const HomeFeedRankingView(),
      latestPostView: const HomeLatestPostView(),
      latestFeedTitle: const HomeLatestFeedTitle(),
      latestFeedView: const HomeLatestFeedView(),
    );
  }
}
