import 'package:flutter/material.dart';
import 'package:grimity/presentation/ranking/ranking_view.dart';
import 'package:grimity/presentation/ranking/view/popular_feed_view.dart';
import 'package:grimity/presentation/ranking/view/poulart_author_view.dart';
import 'package:grimity/presentation/ranking/widget/ranking_app_bar.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RankingView(
      rankingAppBar: RankingAppBar(),
      popularFeedView: PopularFeedView(),
      popularAuthorView: PopularAuthorView(),
    );
  }
}
