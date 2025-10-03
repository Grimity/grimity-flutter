import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/usecase/feed/get_following_feeds_usecase.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:grimity/presentation/common/mixin/feed_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'following_feed_data_provider.g.dart';

@riverpod
class FollowingFeedData extends _$FollowingFeedData with FeedMixin<Feeds> {
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
                          ? e.copyWith(isLike: like, likeCount: like ? e.likeCount! + 1 : e.likeCount! - 1)
                          : e,
                )
                .toList(),
      );
    },
  );
}
