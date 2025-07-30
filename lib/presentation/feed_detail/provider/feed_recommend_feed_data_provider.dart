import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/usecase/feed/get_latest_feeds_usecase.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_recommend_feed_data_provider.g.dart';

@riverpod
class FeedRecommendFeedData extends _$FeedRecommendFeedData {
  @override
  FutureOr<Feeds> build() async {
    final GetLatestFeedsRequestParam param = GetLatestFeedsRequestParam(size: 8);

    final result = await getLatestFeedsUseCase.execute(param);

    return result.fold(onSuccess: (feeds) => feeds, onFailure: (e) => Feeds(feeds: [], nextCursor: ''));
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
