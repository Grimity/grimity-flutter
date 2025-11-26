import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:grimity/presentation/search/provider/search_feed_sort_type_provider.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_feed_data_provider.g.dart';

@riverpod
class SearchFeedData extends _$SearchFeedData {
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

  void invalidateSearchFeed(WidgetRef ref) {
    final keyword = ref.read(searchKeywordProvider);
    final sort = ref.read(searchFeedSortTypeProvider);

    ref.invalidate(searchFeedDataProvider(keyword: keyword, sort: sort));
  }
}
