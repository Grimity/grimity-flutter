import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/presentation/common/widget/grimity_feed_grid.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/system/sort/grimity_search_sort_header.dart';
import 'package:grimity/presentation/search/provider/search_feed_data_provider.dart';
import 'package:grimity/presentation/search/provider/search_feed_sort_type_provider.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 검색 결과 피드 View
class SearchFeedTabView extends HookConsumerWidget with SearchFeedMixin {
  const SearchFeedTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return searchFeedState(ref).when(
      data: (data) {
        final feeds = data.feeds;

        if (feeds.isEmpty) {
          return GrimityStateView.resultNull(title: '검색 결과가 없어요', subTitle: '다른 검색어를 입력해보세요');
        }

        return GrimityInfiniteScrollPagination(
          isEnabled: data.nextCursor != null,
          onLoadMore: searchFeedNotifier(ref).loadMore,
          child: _SearchResultFeedView(feeds: data),
        );
      },
      loading: () => Skeletonizer(child: _SearchResultFeedView(feeds: Feeds(feeds: Feed.emptyList, totalCount: 0))),
      error: (e, s) => GrimityStateView.error(onTap: () => invalidateSearchFeed(ref)),
    );
  }
}

class _SearchResultFeedView extends StatelessWidget {
  const _SearchResultFeedView({required this.feeds});

  final Feeds feeds;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8),
            sliver: SliverToBoxAdapter(child: _SearchFeedSortHeader(resultCount: feeds.totalCount ?? 0)),
          ),
          _SearchFeedListView(feeds: feeds.feeds),
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
    final searchKeyword = ref.watch(searchKeywordProvider);

    return GrimityFeedGrid.sliver(
      feeds: feeds,
      keyword: searchKeyword,
      onToggleLike:
          (feed) => searchFeedNotifier(ref).toggleLike(feedId: feed.id, like: feed.isLike == true ? false : true),
    );
  }
}
