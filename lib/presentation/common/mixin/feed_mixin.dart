import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/util/sync_util.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';

mixin FeedMixin<T> {
  AsyncValue<T> get state;

  set state(AsyncValue<T> value);

  /// Feed Like/unLike
  Future<void> onToggleLike({
    required String feedId,
    required bool like,
    required T Function(T prev) optimisticBuilder,
  }) async {
    final prev = state.valueOrNull;
    if (prev == null) return;

    final optimistic = optimisticBuilder(prev);
    state = AsyncValue.data(optimistic);

    final result = like ? await likeFeedUseCase.execute(feedId) : await unlikeFeedUseCase.execute(feedId);

    result.fold(
      onSuccess: (_) {},
      onFailure: (e) {
        state = AsyncValue.error(e, StackTrace.current);
        state = AsyncValue.data(prev);
      },
    );

    assert(state.value is Feed);
    SyncUtil.feed.notify(state.value as Feed);
  }

  /// Feed save, remove
  Future<void> onToggleSave({
    required String feedId,
    required bool save,
    required T Function(T prev) optimisticBuilder,
  }) async {
    final prev = state.valueOrNull;
    if (prev == null) return;

    final optimistic = optimisticBuilder(prev);
    state = AsyncValue.data(optimistic);

    final result = save ? await saveFeedUseCase.execute(feedId) : await removeSavedFeedUseCase.execute(feedId);

    result.fold(
      onSuccess: (_) {},
      onFailure: (e) {
        state = AsyncValue.error(e, StackTrace.current);
        state = AsyncValue.data(prev);
      },
    );

    assert(state.value is Feed);
    SyncUtil.feed.notify(state.value as Feed);
  }
}
