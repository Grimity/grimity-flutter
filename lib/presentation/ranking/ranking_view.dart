import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RankingView extends StatelessWidget {
  const RankingView({
    super.key,
    required this.rankingAppBar,
    required this.popularFeedView,
    required this.popularAuthorView,
  });

  final Widget rankingAppBar;
  final Widget popularFeedView;
  final Widget popularAuthorView;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        rankingAppBar,
        SliverToBoxAdapter(child: Gap(24)),
        SliverToBoxAdapter(child: popularFeedView),
        SliverToBoxAdapter(child: Gap(50)),
        SliverToBoxAdapter(child: popularAuthorView),
        SliverToBoxAdapter(child: Gap(50)),
      ],
    );
  }
}
