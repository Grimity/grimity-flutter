import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/util/sync_util.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';

mixin PostMixin<T> {
  AsyncValue<T> get state;

  set state(AsyncValue<T> value);

  /// State 에서 알림 대상 Feed 추출
  Post? getNotifyPost(T value, String postId);

  /// Post 알림
  void notifyPost(Post post) {
    SyncUtil.post.notify(post);
  }

  /// Posts 알림
  void notifyPosts(List<Post> posts) {
    for (final post in posts) {
      notifyPost(post);
    }
  }

  /// postId 기준 정의된 [getNotifyPost]로 Post를 찾아 알림
  void notifyPostById(String postId) {
    final value = state.valueOrNull;
    if (value == null) return;

    final post = getNotifyPost(value, postId);
    if (post != null) {
      notifyPost(post);
    }
  }

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
      onSuccess: (_) {
        notifyPostById(postId);
      },
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
      onSuccess: (_) {
        notifyPostById(postId);
      },
      onFailure: (e) {
        state = AsyncValue.error(e, StackTrace.current);
        state = AsyncValue.data(prev);
      },
    );
  }
}
