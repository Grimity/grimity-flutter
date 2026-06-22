import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_feed_grid.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/ranking/provider/popluar_feed_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 인기 그림 순위
class PopularFeedView extends ConsumerWidget {
  const PopularFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularFeed = ref.watch(popularFeedRankingDataProvider);

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      sliver: popularFeed.when(
        data: (feeds) => _PopularFeedListView(feeds: feeds),
        loading: () {
          return Skeletonizer.sliver(child: _PopularFeedListView(feeds: Feed.createEmptyList(context)));
        },
        error: (_, _) {
          return SliverToBoxAdapter(
            child: GrimityStateView.error(onTap: () => ref.invalidate(popularFeedRankingDataProvider)),
          );
        },
      ),
    );
  }
}

class _PopularFeedListView extends StatelessWidget {
  const _PopularFeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context) {
    return GrimityFeedGrid.sliver(feeds: feeds);
  }
}
