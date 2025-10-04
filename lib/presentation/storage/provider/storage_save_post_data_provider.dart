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

  Future<void> toggleSave({required String postId, required bool save}) => onToggleSave(
    postId: postId,
    save: save,
    optimisticBuilder: (prev) {
      return prev.copyWith(posts: prev.posts.map((e) => e.id == postId ? e.copyWith(isSave: save) : e).toList());
    },
  );
}
