import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/comment.dart';

part 'comment_item.freezed.dart';

@freezed
sealed class CommentItem with _$CommentItem {
  const factory CommentItem.parent(Comment comment) = ParentCommentItem;

  const factory CommentItem.child(Comment comment, Comment parentComment) = ChildCommentItem;
}
