import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/usecase/me/get_save_posts_usecase.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/presentation/common/mixin/pagination_mixin.dart';
import 'package:grimity/presentation/common/mixin/post_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_save_post_data_provider.g.dart';

// 저장한 게시글 데이터
@riverpod
class SavePostData extends _$SavePostData with PaginationMixin, PostMixin<Posts> {
  @override
  FutureOr<Posts> build() async {
    return await _fetch(currentPage);
  }

  @override
  Post? getNotifyPost(Posts value, String postId) {
    for (final post in value.posts) {
      if (post.id == postId) {
        return post;
      }
    }
    return null;
  }

  Future<Posts> _fetch(int page) async {
    final GetSavePostsRequestParam param = GetSavePostsRequestParam(page: page, size: size);

    final result = await getSavePostsUseCase.execute(param);

    return result.fold(
      onSuccess: (posts) {
        notifyPosts(posts.posts);
        return posts;
      },
      onFailure: (e) => Posts(posts: [], totalCount: 0),
    );
  }

  Future<void> goToPage(int page) async {
    setPagination(page: page);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(page));
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null) {
      return;
    }

    final loadedCount = currentState.posts.length;
    final totalCount = currentState.totalCount ?? loadedCount;
    if (loadedCount >= totalCount) {
      return;
    }

    final nextPage = currentPage + 1;
    setPagination(page: nextPage);

    final nextPosts = await _fetch(nextPage);
    state = AsyncValue.data(
      currentState.copyWith(
        posts: [...currentState.posts, ...nextPosts.posts],
        totalCount: nextPosts.totalCount ?? currentState.totalCount,
      ),
    );
  }

  Future<void> removeSave({required String postId}) => onToggleSave(
    postId: postId,
    save: false,
    optimisticBuilder: (prev) {
      return prev.copyWith(
        posts:
            prev.posts
                .where(
                  (e) => e.id != postId,
                )
                .toList(),
      );
    },
  );
}
