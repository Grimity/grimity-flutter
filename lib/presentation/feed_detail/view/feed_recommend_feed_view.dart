import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_recommend_feed_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FeedRecommendFeedView extends ConsumerWidget {
  const FeedRecommendFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendFeed = ref.watch(feedRecommendFeedDataProvider);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('추천 그림', style: AppTypeface.subTitle1),
          Gap(16),
          recommendFeed.maybeWhen(
            data: (data) => _RecommendFeedListView(feeds: data.feeds),
            orElse: () => Skeletonizer(child: _RecommendFeedListView(feeds: Feed.emptyList)),
          ),
        ],
      ),
    );
  }
}

class _RecommendFeedListView extends ConsumerWidget {
  const _RecommendFeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int rowCount = (feeds.length / 2).ceil();

    return LayoutGrid(
      columnSizes: [1.fr, 1.fr],
      rowSizes: List.generate(rowCount, (_) => auto),
      rowGap: 20,
      columnGap: 12,
      children: [
        for (var feed in feeds)
          GrimityImageFeed(
            feed: feed,
            onToggleLike:
                () => ref
                    .read(feedRecommendFeedDataProvider.notifier)
                    .toggleLikeFeed(feedId: feed.id, like: feed.isLike == true ? false : true),
          ),
      ],
    );
  }
}
