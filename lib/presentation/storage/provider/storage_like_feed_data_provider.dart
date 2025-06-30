import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:grimity/domain/usecase/me/get_like_feeds_usecase.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_like_feed_data_provider.g.dart';

// 좋아요한 그림 데이터
@riverpod
class LikeFeedData extends _$LikeFeedData {
  @override
  FutureOr<Feeds> build() async {
    final GetLikeFeedsRequestParam param = GetLikeFeedsRequestParam(size: 10);

    final result = await getLikeFeedsUseCase.execute(param);

    return result.fold(onSuccess: (feeds) => feeds, onFailure: (e) => Feeds(feeds: [], nextCursor: ''));
  }

  // Infinite Scroll
  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.nextCursor == null || currentState.nextCursor!.isEmpty) {
      return;
    }

    final param = GetLikeFeedsRequestParam(size: 10, cursor: currentState.nextCursor);
    final result = await getLikeFeedsUseCase.execute(param);

    result.fold(
      onSuccess: (newFeeds) {
        final updatedFeeds = Feeds(feeds: [...currentState.feeds, ...newFeeds.feeds], nextCursor: newFeeds.nextCursor);
        state = AsyncValue.data(updatedFeeds);
      },
      onFailure: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  Future<void> toggleLikeFeed({required String feedId, required bool like}) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final result = like ? await likeFeedUseCase.execute(feedId) : await unlikeFeedUseCase.execute(feedId);

    result.fold(
      onSuccess: (data) {
        final updateFeedList = currentState.feeds.map((e) => e.id == feedId ? e.copyWith(isLike: like) : e).toList();
        final updatedFeeds = Feeds(feeds: updateFeedList, nextCursor: currentState.nextCursor);

        state = AsyncValue.data(updatedFeeds);
      },
      onFailure: (error) {
        return state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }
}
