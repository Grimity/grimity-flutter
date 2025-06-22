import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/usecase/me/get_save_posts_usecase.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_save_post_data_provider.g.dart';

/// TODO 페이징 처리 필요
// 저장한 게시글 데이터
@riverpod
class SavePostData extends _$SavePostData {
  @override
  FutureOr<Posts> build() async {
    final GetSavePostsRequestParam param = GetSavePostsRequestParam(page: 1, size: 10);

    final result = await getSavePostsUseCase.execute(param);

    return result.fold(onSuccess: (posts) => posts, onFailure: (e) => Posts(posts: [], totalCount: 0));
  }

  // Infinite Scroll
  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null ||
        currentState.totalCount == null ||
        currentState.totalCount == 0 ||
        currentState.totalCount! <= currentState.posts.length) {
      return;
    }

    final size = 10;
    final page = currentState.posts.length ~/ size + 1;
    final param = GetSavePostsRequestParam(size: size, page: page);
    final result = await getSavePostsUseCase.execute(param);

    result.fold(
      onSuccess: (newPosts) {
        final updatedPosts = Posts(posts: [...currentState.posts, ...newPosts.posts], totalCount: newPosts.totalCount);
        state = AsyncValue.data(updatedPosts);
      },
      onFailure: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  Future<void> toggleSavePost({required String postId, required bool save}) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final result = save ? await savePostUseCase.execute(postId) : await removeSavedPostUseCase.execute(postId);

    result.fold(
      onSuccess: (data) {
        final updateFeedList = currentState.posts.map((e) => e.id == postId ? e.copyWith(isSave: save) : e).toList();
        final updatedFeeds = Posts(posts: updateFeedList, nextCursor: currentState.nextCursor);

        state = AsyncValue.data(updatedFeeds);
      },
      onFailure: (error) {
        return state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }
}
