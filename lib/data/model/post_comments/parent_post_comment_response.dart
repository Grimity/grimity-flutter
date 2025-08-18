import 'package:grimity/data/model/post_comments/child_post_comment_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/comment.dart';

part 'parent_post_comment_response.freezed.dart';

part 'parent_post_comment_response.g.dart';

@Freezed(copyWith: false)
abstract class ParentPostCommentResponse with _$ParentPostCommentResponse {
  factory ParentPostCommentResponse({
    required String id,
    required String content,
    required DateTime createdAt,
    required int likeCount,
    required bool isLike,
    UserBaseResponse? writer,
    required bool isDeleted,
    required List<ChildPostCommentResponse> childComments,
  }) = _ParentPostCommentResponse;

  factory ParentPostCommentResponse.fromJson(Map<String, dynamic> json) => _$ParentPostCommentResponseFromJson(json);
}

extension ParentPostCommentResponseX on ParentPostCommentResponse {
  Comment toEntity() {
    return Comment(
      id: id,
      content: content,
      createdAt: createdAt,
      likeCount: likeCount,
      isLike: isLike,
      writer: writer?.toEntity(),
      isDeleted: isDeleted,
      childComments: childComments.toEntity(),
    );
  }
}

extension ListCParentPostCommentResponseX on List<ParentPostCommentResponse> {
  List<Comment> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
