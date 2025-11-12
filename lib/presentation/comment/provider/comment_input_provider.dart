import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/provider/comments_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_input_provider.g.dart';

part 'comment_input_provider.freezed.dart';

@riverpod
class CommentInput extends _$CommentInput {
  FocusNode? _focusNode;

  @override
  CommentInputState build(CommentType type) {
    return CommentInputState();
  }

  Future<void> createComment({required String id}) async {
    setUploading(true);
    try {
      final result = await ref
          .read(commentsDataProvider(type, id).notifier)
          .createComment(
            content: state.content,
            parentCommentId: state.parentCommentId,
            mentionedUserId: state.mentionedUserId,
          );

      if (result) {
        ToastService.show('댓글이 등록되었습니다.');
        state = CommentInputState();
      } else {
        ToastService.showError('댓글 등록에 실패했습니다.');
      }
    } finally {
      setUploading(false);
    }
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  void updateCommentReplyState({
    required String parentCommentId,
    String? mentionedUserId,
    required String replyUserName,
  }) {
    clearReplyState();
    state = state.copyWith(
      parentCommentId: parentCommentId,
      mentionedUserId: mentionedUserId,
      replyUserName: replyUserName,
    );
  }

  void clearReplyState() {
    state = state.copyWith(parentCommentId: null, mentionedUserId: null, replyUserName: null);
  }

  void setUploading(bool uploading) {
    state = state.copyWith(uploading: uploading);
  }

  void setFocusNode(FocusNode? focusNode) => _focusNode = focusNode;
  FocusNode? get focusNode => _focusNode;
}

@freezed
abstract class CommentInputState with _$CommentInputState {
  const factory CommentInputState({
    @Default('') String content,
    String? parentCommentId,
    String? mentionedUserId,
    String? replyUserName,
    @Default(false) bool uploading,
  }) = _CommentInputState;
}
