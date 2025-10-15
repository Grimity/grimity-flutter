import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:grimity/presentation/common/mixin/feed_mixin.dart';
import 'package:grimity/presentation/search/provider/search_feed_sort_type_provider.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_feed_data_provider.g.dart';

@riverpod
class SearchFeedData extends _$SearchFeedData with FeedMixin<Feeds> {
  @override
  FutureOr<Feeds> build({required String keyword, required SortType sort}) async {
    final param = SearchFeedRequest(size: 10, keyword: keyword, sort: sort);
    final result = await searchFeedUseCase.execute(param);
    return result.fold(onSuccess: (feeds) => feeds, onFailure: (e) => Feeds(feeds: [], nextCursor: ''));
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.nextCursor == null || currentState.nextCursor!.isEmpty) {
      return;
    }

    final param = SearchFeedRequest(size: 10, cursor: currentState.nextCursor, keyword: keyword, sort: sort);
    final result = await searchFeedUseCase.execute(param);

    result.fold(
      onSuccess: (newFeeds) {
        final updatedFeeds = newFeeds.copyWith(feeds: [...currentState.feeds, ...newFeeds.feeds]);
        state = AsyncValue.data(updatedFeeds);
      },
      onFailure: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  Future<void> toggleLike({required String feedId, required bool like}) => onToggleLike(
    feedId: feedId,
    like: like,
    optimisticBuilder: (prev) {
      return prev.copyWith(
        feeds:
            prev.feeds
                .map(
                  (e) =>
                      e.id == feedId
                          ? e.copyWith(likeCount: like ? e.likeCount! + 1 : e.likeCount! - 1, isLike: like)
                          : e,
                )
                .toList(),
      );
    },
  );
}

mixin class SearchFeedMixin {
  AsyncValue<Feeds> searchFeedState(WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);
    final sort = ref.watch(searchFeedSortTypeProvider);

    return ref.watch(searchFeedDataProvider(keyword: keyword, sort: sort));
  }

  SearchFeedData searchFeedNotifier(WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);
    final sort = ref.watch(searchFeedSortTypeProvider);

    return ref.read(searchFeedDataProvider(keyword: keyword, sort: sort).notifier);
  }
}
