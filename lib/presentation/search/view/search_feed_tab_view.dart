import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_feed_grid.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/search/provider/search_feed_data_provider.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:grimity/presentation/search/view/search_empty_state.dart';
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
          return SearchEmptyState();
        }

        return GrimityInfiniteScrollPagination(
          isEnabled: data.nextCursor != null,
          onLoadMore: searchFeedNotifier(ref).loadMore,
          child: _SearchFeedListView(feeds: data.feeds),
        );
      },
      loading: () {
        return Skeletonizer(
          child: _SearchFeedListView(feeds: Feed.createEmptyList(context)),
        );
      },
      error: (e, s) => GrimityStateView.error(onTap: () => invalidateSearchFeed(ref)),
    );
  }
}

class _SearchFeedListView extends ConsumerWidget with SearchFeedMixin {
  const _SearchFeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchKeyword = ref.watch(searchKeywordProvider);

    return CustomScrollView(
      slivers: [
        GrimityFeedGrid.sliver(
          feeds: feeds,
          keyword: searchKeyword,
          padding: EdgeInsets.all(
            context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
          ),
        ),
      ],
    );
  }
}
