import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_detail_data_provider.g.dart';

@riverpod
class PostDetailData extends _$PostDetailData {
  @override
  FutureOr<Post?> build(String postId) async {
    final result = await getPostDetailUseCase.execute(postId);

    return result.fold(onSuccess: (post) => post, onFailure: (e) => null);
  }

  /// 게시글 삭제
  FutureOr<bool> deletePost(String id) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return false;

    final result = await deletePostUseCase.execute(id);

    final isSuccess = result.fold(
      onSuccess: (value) {
        ToastService.show('삭제가 완료되었습니다.');
        return true;
      },
      onFailure: (e) {
        ToastService.showError('삭제가 실패되었습니다.');
        return false;
      },
    );
    return isSuccess;
  }

  /// 좋아요 토글
  Future<void> toggleLikePost(String postId, bool like) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final result = like ? await likePostUseCase.execute(postId) : await unlikePostUseCase.execute(postId);

    if (result.isSuccess) {
      final updatedPost = currentState.copyWith(
        likeCount: like ? currentState.likeCount! + 1 : currentState.likeCount! - 1,
        isLike: like,
      );
      state = AsyncValue.data(updatedPost);
    }
  }

  /// 저장 토글
  Future<void> toggleSavePost(String postId, bool save) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final result = save ? await savePostUseCase.execute(postId) : await removeSavedPostUseCase.execute(postId);

    if (result.isSuccess) {
      final updatedPost = currentState.copyWith(isSave: save);
      state = AsyncValue.data(updatedPost);
    }
  }
}
