import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';
import 'package:grimity/presentation/home/hook/use_infinite_scroll_hook.dart';
import 'package:grimity/presentation/storage/enum/storage_enum_item.dart';
import 'package:grimity/presentation/storage/provider/storage_like_feed_data_provider.dart';
import 'package:grimity/presentation/storage/widget/storage_empty_widget.dart';
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
      child: likeFeed.maybeWhen(
        data:
            (data) =>
                data.feeds.isEmpty
                    ? StorageEmptyWidget(emptyMessage: StorageTabType.likeFeed.emptyMessage)
                    : _StorageLikeFeedListView(feeds: data.feeds),
        orElse: () => Skeletonizer(child: _StorageLikeFeedListView(feeds: Feed.emptyList)),
      ),
    );
  }
}

class _StorageLikeFeedListView extends HookConsumerWidget {
  const _StorageLikeFeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int rowCount = (feeds.length / 2).ceil();
    final scrollController = useScrollController();

    useInfiniteScrollHook(
      ref: ref,
      scrollController: scrollController,
      loadFunction: () async => await ref.read(likeFeedDataProvider.notifier).loadMore(),
    );

    return SingleChildScrollView(
      controller: scrollController,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: LayoutGrid(
          columnSizes: [1.fr, 1.fr],
          rowSizes: List.generate(rowCount, (_) => auto),
          rowGap: 20,
          columnGap: 12,
          children:
              feeds
                  .map(
                    (feed) => GrimityImageFeed(
                      feed: feed,
                      onToggleLike:
                          () => ref
                              .read(likeFeedDataProvider.notifier)
                              .toggleLike(feedId: feed.id, like: feed.isLike == true ? false : true),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
