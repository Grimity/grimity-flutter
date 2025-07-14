import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/usecase/me/get_save_posts_usecase.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';
import 'package:grimity/presentation/common/mixin/pagination_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_save_post_data_provider.g.dart';

// 저장한 게시글 데이터
@riverpod
class SavePostData extends _$SavePostData with PaginationMixin {
  @override
  FutureOr<Posts> build() async {
    return await _fetch(currentPage);
  }

  Future<Posts> _fetch(int page) async {
    final GetSavePostsRequestParam param = GetSavePostsRequestParam(page: currentPage, size: size);

    final result = await getSavePostsUseCase.execute(param);

    return result.fold(onSuccess: (posts) => posts, onFailure: (e) => Posts(posts: [], totalCount: 0));
  }

  Future<void> goToPage(int page) async {
    setPagination(page: page);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(page));
  }

  Future<void> toggleSavePost({required String postId, required bool save}) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final result = save ? await savePostUseCase.execute(postId) : await removeSavedPostUseCase.execute(postId);

    result.fold(
      onSuccess: (data) {
        final updatePostList = currentState.posts.map((e) => e.id == postId ? e.copyWith(isSave: save) : e).toList();
        final updatedPosts = Posts(posts: updatePostList, totalCount: currentState.totalCount);
        state = AsyncValue.data(updatedPosts);
      },
      onFailure: (error) {
        return state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }
}