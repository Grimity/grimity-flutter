import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_feed_grid.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeLatestFeedTitle extends StatelessWidget {
  const HomeLatestFeedTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text('최신 그림', style: AppTypeface.subTitle1),
    );
  }
}

class HomeLatestFeedView extends ConsumerWidget {
  const HomeLatestFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestFeed = ref.watch(latestFeedDataProvider);

    return latestFeed.when(
      data:
          (data) => GrimityFeedGrid.sliver(
            feeds: data.feeds,
            onToggleLike:
                (feed) => ref
                    .read(latestFeedDataProvider.notifier)
                    .toggleLike(feedId: feed.id, like: feed.isLike == true ? false : true),
          ),
      loading: () => SliverToBoxAdapter(child: Skeletonizer(child: GrimityFeedGrid(feeds: Feed.emptyList))),
      error:
          (e, s) =>
              SliverToBoxAdapter(child: GrimityStateView.error(onTap: () => ref.invalidate(latestFeedDataProvider))),
    );
  }
}
