import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_feed_grid.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_recommend_feed_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FeedRecommendFeedView extends ConsumerWidget {
  const FeedRecommendFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendFeed = ref.watch(feedRecommendFeedDataProvider);
    final scrollSpacing = context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20;
    final scrollPadding = EdgeInsets.only(
      left: scrollSpacing,
      right: scrollSpacing,
      bottom: scrollSpacing,
    );

    return recommendFeed.when(
      data: (data) {
        return GrimityFeedGrid.sliver(feeds: data.feeds, padding: scrollPadding);
      },
      loading: () {
        return Skeletonizer.sliver(
          child: GrimityFeedGrid.sliver(feeds: Feed.createEmptyList(context), padding: scrollPadding),
        );
      },
      error: (_, _) {
        return SliverToBoxAdapter(
          child: GrimityStateView.error(onTap: () => ref.invalidate(feedRecommendFeedDataProvider)),
        );
      },
    );
  }
}
