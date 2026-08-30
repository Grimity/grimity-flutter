import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_feed_grid.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:grimity/presentation/home/widget/home_section_header.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeLatestFeedTitle extends StatelessWidget {
  const HomeLatestFeedTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeSectionHeader(
      title: '최신 그림',
    );
  }
}

class HomeLatestFeedView extends ConsumerWidget {
  const HomeLatestFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestFeed = ref.watch(latestFeedDataProvider);

    return latestFeed.when(
      data: (data) => GrimityFeedGrid.sliver(feeds: data.feeds),
      loading: () => SliverToBoxAdapter(
        child: Skeletonizer(child: GrimityFeedGrid(feeds: Feed.createEmptyList(context))),
      ),
      error: (e, s) =>
          SliverToBoxAdapter(child: GrimityStateView.error(onTap: () => ref.invalidate(latestFeedDataProvider))),
    );
  }
}
