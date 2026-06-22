import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/provider/author_with_feeds_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/ranking/provider/popluar_feed_data_provider.dart';
import 'package:grimity/presentation/ranking/provider/popular_tag_data_provider.dart';
import 'package:grimity/presentation/ranking/widget/ranking_header.dart';
import 'package:grimity/presentation/ranking/widget/ranking_tab.dart';

class RankingView extends ConsumerWidget {
  const RankingView({
    super.key,
    required this.rankingAppBar,
    required this.popularFeedView,
    required this.popularPeriodView,
    required this.popularAuthorView,
    required this.popularTagView,
  });

  final Widget rankingAppBar;
  final Widget popularFeedView;
  final Widget popularPeriodView;
  final Widget popularAuthorView;
  final Widget popularTagView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GdsScaffold(
      appBar: rankingAppBar,
      body: AppBarConnection(
        appBars: [
          RankingHeader.createAppBar(),
          RankingTab.createAppBar(),
        ],
        child: GrimityRefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              ref.refresh(popularFeedRankingDataProvider.future),
              ref.refresh(authorWithFeedsDataProvider.future),
              ref.refresh(popularTagDataProvider.future),
            ]);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: popularPeriodView),
              popularFeedView,
              SliverToBoxAdapter(child: Gap(context.isMobile ? GdsSpacing.spacing32 : GdsSpacing.spacing56)),
              SliverToBoxAdapter(child: popularAuthorView),
              SliverToBoxAdapter(child: Gap(context.isMobile ? GdsSpacing.spacing32 : GdsSpacing.spacing56)),
              SliverToBoxAdapter(child: popularTagView),
              SliverToBoxAdapter(child: Gap(context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing40)),
            ],
          ),
        ),
      ),
    );
  }
}
