import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_feed_grid.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/storage/enum/storage_enum_item.dart';
import 'package:grimity/presentation/storage/provider/storage_like_feed_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StorageLikeFeedView extends HookConsumerWidget {
  const StorageLikeFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final likeFeed = ref.watch(likeFeedDataProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: likeFeed.when(
        data: (data) {
          final feeds = data.feeds;

          if (feeds.isEmpty) {
            return GrimityStateView.resultNull(subTitle: StorageTabType.likeFeed.emptyMessage);
          }

          return GrimityInfiniteScrollPagination(
            isEnabled: data.nextCursor != null,
            onLoadMore: ref.read(likeFeedDataProvider.notifier).loadMore,
            child: _StorageLikeFeedListView(feeds: feeds),
          );
        },
        loading: () => Skeletonizer(child: _StorageLikeFeedListView(feeds: Feed.emptyList)),
        error: (error, stackTrace) => GrimityStateView.error(onTap: () => ref.invalidate(likeFeedDataProvider)),
      ),
    );
  }
}

class _StorageLikeFeedListView extends ConsumerWidget {
  const _StorageLikeFeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        GrimityFeedGrid.sliver(
          feeds: feeds,
          onToggleLike:
              (feed) => ref
                  .read(likeFeedDataProvider.notifier)
                  .toggleLike(feedId: feed.id, like: feed.isLike == true ? false : true),
        ),
      ],
    );
  }
}
