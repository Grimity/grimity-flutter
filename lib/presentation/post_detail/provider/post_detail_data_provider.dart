import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';
import 'package:grimity/presentation/common/mixin/post_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_detail_data_provider.g.dart';

@riverpod
class PostDetailData extends _$PostDetailData with PostMixin<Post?> {
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

  Future<void> toggleLike({required String postId, required bool like}) => onToggleLike(
    postId: postId,
    like: like,
    optimisticBuilder: (prev) {
      return prev?.copyWith(likeCount: like ? prev.likeCount! + 1 : prev.likeCount! - 1, isLike: like);
    },
  );

  Future<void> toggleSave({required String postId, required bool save}) => onToggleSave(
    postId: postId,
    save: save,
    optimisticBuilder: (prev) {
      return prev?.copyWith(isSave: save);
    },
  );
}
