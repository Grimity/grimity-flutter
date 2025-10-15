import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';
import 'package:grimity/presentation/common/widget/system/sort/grimity_search_sort_header.dart';
import 'package:grimity/presentation/home/hook/use_infinite_scroll_hook.dart';
import 'package:grimity/presentation/search/provider/search_feed_data_provider.dart';
import 'package:grimity/presentation/search/provider/search_feed_sort_type_provider.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:grimity/presentation/search/widget/search_empty_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 검색 결과 피드 View
class SearchFeedTabView extends HookConsumerWidget with SearchFeedMixin {
  const SearchFeedTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return searchFeedState(ref).maybeWhen(
      data: (feeds) => feeds.feeds.isEmpty ? SearchEmptyWidget() : _SearchResultFeedView(feeds: feeds),
      orElse: () => GrimityCircularProgressIndicator(),
    );
  }
}

class _SearchResultFeedView extends HookConsumerWidget with SearchFeedMixin {
  const _SearchResultFeedView({required this.feeds});

  final Feeds feeds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useInfiniteScrollHook(
      ref: ref,
      scrollController: scrollController,
      loadFunction: () async => await searchFeedNotifier(ref).loadMore(),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8),
            sliver: SliverToBoxAdapter(child: _SearchFeedSortHeader(resultCount: feeds.totalCount ?? 0)),
          ),
          SliverToBoxAdapter(child: _SearchFeedListView(feeds: feeds.feeds)),
        ],
      ),
    );
  }
}

class _SearchFeedSortHeader extends ConsumerWidget {
  const _SearchFeedSortHeader({required this.resultCount});

  final int resultCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortType = ref.watch(searchFeedSortTypeProvider);

    return GrimitySearchSortHeader(
      resultCount: resultCount,
      sortValue: sortType,
      sortItems:
          SortType.searchFeedSortValues
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.typeName, style: AppTypeface.caption2.copyWith(color: AppColor.gray700)),
                ),
              )
              .toList(),
      onSortChanged: (value) {
        if (value == null) return;
        ref.read(searchFeedSortTypeProvider.notifier).update(value);
      },
      padding: EdgeInsets.zero,
    );
  }
}

class _SearchFeedListView extends ConsumerWidget with SearchFeedMixin {
  const _SearchFeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int rowCount = (feeds.length / 2).ceil();
    final searchKeyword = ref.watch(searchKeywordProvider);

    return LayoutGrid(
      columnSizes: [1.fr, 1.fr],
      rowSizes: List.generate(rowCount, (_) => auto),
      rowGap: 20,
      columnGap: 12,
      children: [
        for (var feed in feeds)
          GrimityImageFeed(
            feed: feed,
            keyword: searchKeyword,
            onToggleLike:
                () => searchFeedNotifier(ref).toggleLike(feedId: feed.id, like: feed.isLike == true ? false : true),
          ),
      ],
    );
  }
}
