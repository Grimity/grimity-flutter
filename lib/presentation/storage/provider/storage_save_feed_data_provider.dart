import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/usecase/me/get_save_feeds_usecase.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_save_feed_data_provider.g.dart';

// 저장한 그림 데이터
@riverpod
class SaveFeedData extends _$SaveFeedData {
  @override
  FutureOr<Feeds> build() async {
    final GetSaveFeedsRequestParam param = GetSaveFeedsRequestParam(size: 10);

    final result = await getSaveFeedsUseCase.execute(param);

    return result.fold(
      onSuccess: (feeds) => feeds,
      onFailure: (e) => Feeds(feeds: [], nextCursor: ''),
    );
  }

  // Infinite Scroll
  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || currentState.nextCursor == null || currentState.nextCursor!.isEmpty) {
      return;
    }

    final param = GetSaveFeedsRequestParam(size: 10, cursor: currentState.nextCursor);
    final result = await getSaveFeedsUseCase.execute(param);

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
