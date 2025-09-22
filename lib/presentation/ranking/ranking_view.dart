import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/presentation/common/provider/author_with_feeds_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/ranking/provider/popluar_feed_data_provider.dart';
import 'package:grimity/presentation/ranking/provider/popular_tag_data_provider.dart';

class RankingView extends ConsumerWidget {
  const RankingView({
    super.key,
    required this.rankingAppBar,
    required this.popularFeedView,
    required this.popularAuthorView,
    required this.popularTagView,
  });

  final Widget rankingAppBar;
  final Widget popularFeedView;
  final Widget popularAuthorView;
  final Widget popularTagView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [rankingAppBar],
      body: GrimityRefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(popularFeedRankingDataProvider.future),
            ref.refresh(authorWithFeedsDataProvider.future),
            ref.refresh(popularTagDataProvider.future),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Gap(24)),
            SliverToBoxAdapter(child: popularFeedView),
            SliverToBoxAdapter(child: Gap(50)),
            SliverToBoxAdapter(child: popularAuthorView),
            SliverToBoxAdapter(child: Gap(50)),
            SliverToBoxAdapter(child: popularTagView),
            SliverToBoxAdapter(child: Gap(50)),
          ],
        ),
      ),
    );
  }
}
