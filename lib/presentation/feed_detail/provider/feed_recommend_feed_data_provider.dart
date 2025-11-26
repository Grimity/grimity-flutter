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
}
