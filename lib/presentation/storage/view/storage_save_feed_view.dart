import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_feed_grid.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/storage/enum/storage_enum_item.dart';
import 'package:grimity/presentation/storage/provider/storage_save_feed_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StorageSaveFeedView extends HookConsumerWidget {
  const StorageSaveFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final saveFeed = ref.watch(saveFeedDataProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: saveFeed.when(
        data: (data) {
          final feeds = data.feeds;

          if (feeds.isEmpty) {
            return GrimityStateView.resultNull(subTitle: StorageTabType.saveFeed.emptyMessage);
          }

          return GrimityInfiniteScrollPagination(
            isEnabled: data.nextCursor != null,
            onLoadMore: ref.read(saveFeedDataProvider.notifier).loadMore,
            child: _StorageSaveFeedListView(feeds: feeds),
          );
        },
        loading: () => Skeletonizer(child: _StorageSaveFeedListView(feeds: Feed.emptyList)),
        error: (error, stackTrace) => GrimityStateView.error(onTap: () => ref.invalidate(saveFeedDataProvider)),
      ),
    );
  }
}

class _StorageSaveFeedListView extends ConsumerWidget {
  const _StorageSaveFeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        GrimityFeedGrid.sliver(
          feeds: feeds,
          onToggleSave:
              (feed) => ref
                  .read(saveFeedDataProvider.notifier)
                  .toggleSave(feedId: feed.id, save: feed.isSave == true ? false : true),
        ),
      ],
    );
  }
}
