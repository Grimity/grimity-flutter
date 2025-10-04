import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';
import 'package:grimity/presentation/home/hook/use_infinite_scroll_hook.dart';
import 'package:grimity/presentation/storage/provider/storage_save_feed_data_provider.dart';
import 'package:grimity/presentation/storage/view/storage_empty_view.dart';
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
      child: saveFeed.maybeWhen(
        data: (data) => data.feeds.isEmpty ? StorageEmptyView() : _StorageSaveFeedListView(feeds: data.feeds),
        orElse: () => Skeletonizer(child: _StorageSaveFeedListView(feeds: Feed.emptyList)),
      ),
    );
  }
}

class _StorageSaveFeedListView extends HookConsumerWidget {
  const _StorageSaveFeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int rowCount = (feeds.length / 2).ceil();
    final scrollController = useScrollController();

    useInfiniteScrollHook(
      ref: ref,
      scrollController: scrollController,
      loadFunction: () async => await ref.read(saveFeedDataProvider.notifier).loadMore(),
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
                      onToggleSave:
                          () => ref
                              .read(saveFeedDataProvider.notifier)
                              .toggleSave(feedId: feed.id, save: feed.isSave == true ? false : true),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
