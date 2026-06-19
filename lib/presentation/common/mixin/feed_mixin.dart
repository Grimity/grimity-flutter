import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/util/sync_util.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';

mixin FeedMixin<T> {
  AsyncValue<T> get state;

  set state(AsyncValue<T> value);

  /// State 에서 알림 대상 Feed 추출
  Feed? getNotifyFeed(T value, String feedId);

  /// Feed 알림
  void notifyFeed(Feed feed) {
    SyncUtil.feed.notify(feed);
  }

  /// Feeds 알림
  void notifyFeeds(List<Feed> feeds) {
    for (final feed in feeds) {
      notifyFeed(feed);
    }
  }

  /// feedId 기준 정의된 [getNotifyFeed]로 Feed를 찾아 알림
  void notifyFeedById(String feedId) {
    final value = state.value;
    if (value == null) return;

    final feed = getNotifyFeed(value, feedId);
    if (feed != null) {
      notifyFeed(feed);
    }
  }

  /// Feed Like/unLike
  Future<void> onToggleLike({
    required String feedId,
    required bool like,
    required T Function(T prev) optimisticBuilder,
  }) async {
    final prev = state.value;
    if (prev == null) return;

    final optimistic = optimisticBuilder(prev);
    state = AsyncValue.data(optimistic);

    final result = like ? await likeFeedUseCase.execute(feedId) : await unlikeFeedUseCase.execute(feedId);

    result.fold(
      onSuccess: (_) {
        notifyFeedById(feedId);
      },
      onFailure: (e) {
        state = AsyncValue.error(e, StackTrace.current);
        state = AsyncValue.data(prev);
      },
    );
  }

  /// Feed save, remove
  Future<void> onToggleSave({
    required String feedId,
    required bool save,
    required T Function(T prev) optimisticBuilder,
  }) async {
    final prev = state.value;
    if (prev == null) return;

    final optimistic = optimisticBuilder(prev);
    state = AsyncValue.data(optimistic);

    final result = save ? await saveFeedUseCase.execute(feedId) : await removeSavedFeedUseCase.execute(feedId);

    result.fold(
      onSuccess: (_) {
        notifyFeedById(feedId);
      },
      onFailure: (e) {
        state = AsyncValue.error(e, StackTrace.current);
        state = AsyncValue.data(prev);
      },
    );
  }
}
