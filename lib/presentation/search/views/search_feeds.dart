import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/search/widgets/search_empty_state.dart';
import 'package:grimity/widgets/sliver_feed_grid.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 검색어와 정렬 기준에 대응하는 그림 목록을 표시하는 화면.
class SearchFeeds extends StatelessWidget with GdsTabView {
  const new({super.key});

  @override
  String get label => '그림';

  /// 검색 결과를 불러오는 동안 표시할 임시 피드 데이터.
  static final placeholder = [
    SearchedFeedsResponse(
      feeds: List.generate(20, (_) {
        return .new(
          id: '',
          title: 'Placeholder',
          thumbnail: '',
          likeCount: 1,
          viewCount: 1,
          cards: [],
          createdAt: .now(),
          content: 'Placeholder',
          tags: [],
          author: .new(id: '', name: '', url: ''),
          commentCount: 0,
          isLike: false,
        );
      }),
    ),
  ];

  /// 검색 조건에 대응하는 그림 목록을 조회하는 서비스를 생성합니다.
  static LoadMoreService<SearchedFeedsResponse> createService(
    String keyword,
    FeedSearchSort sort,
  ) {
    return .new(
      builder: (cursor) => GetFeedsSearch(
        cursor: cursor,
        keyword: keyword,
        sort: .latest,
      ),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyword = context.sharedStateFor<String>(
      key: const ValueKey('search-keyword'),
    );

    final sort = context.sharedStateFor<FeedSearchSort>(
      key: const ValueKey('search-sort'),
    );

    final service = context.serviceOf(
      () => createService(keyword.value, sort.value),
      key: ValueKey((keyword.value, sort.value, SearchFeeds)),
    );

    final data = service.maybeData ?? placeholder;
    final feeds = data.expand((e) => e.feeds).toList();

    // 보여줄 수 있는 피드가 아예 없을 경우.
    if (feeds.isEmpty) {
      return const SearchEmptyState();
    }

    return GdsInfiniteScroll(
      onLoadMore: service.loadMore,
      enabled: service.canLoreMore,
      child: SliverScrollView(
        padding: context.whenDevice(
          mobile: .all(16),
          tablet: .all(20),
        ),
        slivers: [
          SliverFeedGrid(
            service: service,
            itemCount: feeds.length,
            itemBuilder: (context, index) {
              final feed = feeds[index];

              return (
                id: feed.id,
                thumbnail: feed.thumbnail,
                title: feed.title,
                nickname: feed.author.name,
                likeCount: feed.likeCount.toInt(),
                viewCount: feed.viewCount.toInt(),
                isLike: feed.isLike,
              );
            },
          ),
        ],
      ),
    );
  }
}
