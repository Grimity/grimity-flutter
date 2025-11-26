import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/usecase/feed/get_latest_feeds_usecase.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:grimity/domain/usecase/post/get_posts_usecase.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_data_provider.g.dart';

@riverpod
class FeedRankingData extends _$FeedRankingData {
  @override
  FutureOr<List<Feed>> build() async {
    final now = DateTime.now();
    final startDate = now.oneWeekBeforeFormatted;
    final endDate = now.toYearMonthDay;
    final result = await getFeedRankingsUseCase.execute(GetFeedRankingsRequest(startDate: startDate, endDate: endDate));

    return result.fold(onSuccess: (feeds) => feeds, onFailure: (e) => []);
  }
}

@riverpod
class LatestPostData extends _$LatestPostData {
  @override
  FutureOr<List<Post>> build() async {
    final GetPostsRequestParam param = GetPostsRequestParam(page: 1, size: 3, type: PostType.all);

    final result = await getPostsUseCase.execute(param);

    return result.fold(onSuccess: (posts) => posts.posts, onFailure: (e) => []);
  }
}

@riverpod
class LatestFeedData extends _$LatestFeedData {
  @override
  FutureOr<Feeds> build() async {
    final GetLatestFeedsRequestParam param = GetLatestFeedsRequestParam(size: 10);

    final result = await getLatestFeedsUseCase.execute(param);

    return result.fold(onSuccess: (feeds) => feeds, onFailure: (e) => Feeds(feeds: [], nextCursor: ''));
  }

  // Infinite Scroll
  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.nextCursor == null || currentState.nextCursor!.isEmpty) {
      return;
    }

    final param = GetLatestFeedsRequestParam(size: 10, cursor: currentState.nextCursor);
    final result = await getLatestFeedsUseCase.execute(param);

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
}
