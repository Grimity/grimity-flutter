import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  }
}
