import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/dto/feed_comments_request_params.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_detail_data_provider.dart';
import 'package:grimity/presentation/post_detail/provider/post_detail_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_data_provider.g.dart';

@riverpod
class CommentsData extends _$CommentsData {
  @override
  FutureOr<List<Comment>> build(CommentType commentType, String id) async {
    if (id.isEmpty) return [];

    final result = await commentType.getCommentsUseCase.execute(id);

    return result.fold(onSuccess: (comments) => comments, onFailure: (e) => []);
  }

  Future<bool> createComment({String? parentCommentId, required String content, String? mentionedUserId}) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return false;

    final request =
        commentType == CommentType.feed
            ? CreateFeedCommentRequest(
              feedId: id,
              content: content,
              parentCommentId: parentCommentId,
              mentionedUserId: mentionedUserId,
            )
            : CreatePostCommentRequest(
              postId: id,
              content: content,
              parentCommentId: parentCommentId,
              mentionedUserId: mentionedUserId,
            );

    final result = await commentType.createCommentUseCase.execute(request);

    return result.fold(
      onSuccess: (value) {
        commentType == CommentType.feed
            ? ref.invalidate(feedDetailDataProvider)
            : ref.invalidate(postDetailDataProvider);
        ref.invalidateSelf();
        return true;
      },
      onFailure: (e) {
        return false;
      },
    );
  }

  Future<void> toggleCommentLike(String commentId, bool like) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final result =
        like
            ? await commentType.likeCommentUseCase.execute(commentId)
            : await commentType.unlikeCommentUseCase.execute(commentId);

    result.fold(
      onSuccess: (value) {
        final updated = _updateCommentLike(currentState, commentId, like);
        state = AsyncValue.data(updated);
      },
      onFailure: (e) {
        ToastService.showError('댓글 좋아요 처리에 실패했습니다.');
      },
    );
  }

  /// 특정 commentId를 찾아 like 상태를 업데이트
  List<Comment> _updateCommentLike(List<Comment> comments, String commentId, bool like) {
    return comments.map((comment) {
      if (comment.id == commentId) {
        return comment.copyWith(isLike: like, likeCount: like ? comment.likeCount + 1 : comment.likeCount - 1);
      }

      // 자식 댓글 재귀 처리
      if (comment.childComments != null) {
        final updatedChildren = _updateCommentLike(comment.childComments!, commentId, like);
        return comment.copyWith(childComments: updatedChildren);
      }

      return comment;
    }).toList();
  }

  Future<void> deleteComment(String commentId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final result = await commentType.deleteCommentsUseCase.execute(commentId);

    result.fold(
      onSuccess: (value) {
        final updated = _deleteCommentRecursive(currentState, commentId);

        state = AsyncValue.data(updated);
      },
      onFailure: (e) {
        ToastService.showError('댓글 삭제에 실패했습니다.');
      },
    );
  }

  /// 주어진 commentId를 가진 댓글(부모 또는 자식)을 트리에서 제거
  List<Comment> _deleteCommentRecursive(List<Comment> comments, String commentId) {
    return comments
        .where((comment) => comment.id != commentId) // 부모가 아닌 경우 유지
        .map((comment) {
          if (comment.childComments != null) {
            final updatedChildren = _deleteCommentRecursive(comment.childComments!, commentId);
            return comment.copyWith(childComments: updatedChildren);
          }
          return comment;
        })
        .toList();
  }
}
