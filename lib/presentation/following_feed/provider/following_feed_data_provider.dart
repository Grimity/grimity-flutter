import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/usecase/feed/get_following_feeds_usecase.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'following_feed_data_provider.g.dart';

@riverpod
class FollowingFeedData extends _$FollowingFeedData {
  @override
  FutureOr<Feeds> build() async {
    final GetFollowingFeedsRequestParam param = GetFollowingFeedsRequestParam(size: 3);

    final result = await getFollowingFeedsUseCase.execute(param);

    return result.fold(onSuccess: (feeds) => feeds, onFailure: (e) => Feeds(feeds: [], nextCursor: ''));
  }

  // Infinite Scroll
  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.nextCursor == null || currentState.nextCursor!.isEmpty) {
      return;
    }

    final param = GetFollowingFeedsRequestParam(size: 3, cursor: currentState.nextCursor);
    final result = await getFollowingFeedsUseCase.execute(param);

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

  /// 좋아요 토글
  Future<void> toggleLikeFeed({required String feedId, required bool like}) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final result = like ? await likeFeedUseCase.execute(feedId) : await unlikeFeedUseCase.execute(feedId);

    result.fold(
      onSuccess: (data) {
        final updateFeedList =
            currentState.feeds
                .map(
                  (e) =>
                      e.id == feedId
                          ? e.copyWith(isLike: like, likeCount: like ? e.likeCount! + 1 : e.likeCount! - 1)
                          : e,
                )
                .toList();
        final updatedFeeds = Feeds(feeds: updateFeedList, nextCursor: currentState.nextCursor);

        state = AsyncValue.data(updatedFeeds);
      },
      onFailure: (error) {
        return state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }
}
