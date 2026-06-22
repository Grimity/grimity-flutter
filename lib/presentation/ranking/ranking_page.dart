import 'package:flutter/material.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_main_top_navigation.dart';
import 'package:grimity/presentation/ranking/ranking_view.dart';
import 'package:grimity/presentation/ranking/view/popular_feed_view.dart';
import 'package:grimity/presentation/ranking/view/popular_period_view.dart';
import 'package:grimity/presentation/ranking/view/popular_tag_view.dart';
import 'package:grimity/presentation/ranking/view/popular_author_view.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RankingView(
      rankingAppBar: GrimityMainTopNavigation(),
      popularFeedView: PopularFeedView(),
      popularPeriodView: PopularPeriodView(),
      popularAuthorView: PopularAuthorView(),
      popularTagView: PopularTagView(),
    );
  }
}
