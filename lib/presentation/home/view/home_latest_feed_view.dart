import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/grimity_image_feed.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeLatestFeedView extends ConsumerWidget {
  const HomeLatestFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestFeed = ref.watch(latestFeedDataProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('최신 그림', style: AppTypeface.subTitle1),
          const Gap(16),
          latestFeed.maybeWhen(
            data: (data) => _LatestFeedListView(feeds: data.feeds),
            orElse: () => Skeletonizer(child: _LatestFeedListView(feeds: Feed.emptyList)),
          ),
        ],
      ),
    );
  }
}

class _LatestFeedListView extends StatelessWidget {
  const _LatestFeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context) {
    final int rowCount = (feeds.length / 2).ceil();

    return LayoutGrid(
      columnSizes: [1.fr, 1.fr],
      rowSizes: List.generate(rowCount, (_) => auto),
      rowGap: 20,
      columnGap: 12,
      children: [for (var feed in feeds) GrimityImageFeed(feed: feed)],
    );
  }
}
