import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';

mixin PostMixin<T> {
  AsyncValue<T> get state;

  set state(AsyncValue<T> value);

  /// Post Like/unLike
  Future<void> onToggleLike({
    required String postId,
    required bool like,
    required T Function(T prev) optimisticBuilder,
  }) async {
    final prev = state.valueOrNull;
    if (prev == null) return;

    final optimistic = optimisticBuilder(prev);
    state = AsyncValue.data(optimistic);

    final result = like ? await likePostUseCase.execute(postId) : await unlikePostUseCase.execute(postId);

    result.fold(
      onSuccess: (_) {},
      onFailure: (e) {
        state = AsyncValue.error(e, StackTrace.current);
        state = AsyncValue.data(prev);
      },
    );
  }

  /// Post save, remove
  Future<void> onToggleSave({
    required String postId,
    required bool save,
    required T Function(T prev) optimisticBuilder,
  }) async {
    final prev = state.valueOrNull;
    if (prev == null) return;

    final optimistic = optimisticBuilder(prev);
    state = AsyncValue.data(optimistic);

    final result = save ? await savePostUseCase.execute(postId) : await removeSavedPostUseCase.execute(postId);

    result.fold(
      onSuccess: (_) {},
      onFailure: (e) {
        state = AsyncValue.error(e, StackTrace.current);
        state = AsyncValue.data(prev);
      },
    );
  }
}
