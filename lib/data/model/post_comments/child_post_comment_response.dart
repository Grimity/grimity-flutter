import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/comment.dart';

part 'child_post_comment_response.freezed.dart';

part 'child_post_comment_response.g.dart';

@Freezed(copyWith: false)
abstract class ChildPostCommentResponse with _$ChildPostCommentResponse {
  factory ChildPostCommentResponse({
    required String id,
    required String content,
    required DateTime createdAt,
    required int likeCount,
    required bool isLike,
    UserBaseResponse? writer,
    UserBaseResponse? mentionedUser,
  }) = _ChildPostCommentResponse;

  factory ChildPostCommentResponse.fromJson(Map<String, dynamic> json) => _$ChildPostCommentResponseFromJson(json);
}

extension ChildPostCommentResponseX on ChildPostCommentResponse {
  Comment toEntity() {
    return Comment(
      id: id,
      content: content,
      createdAt: createdAt,
      likeCount: likeCount,
      isLike: isLike,
      writer: writer?.toEntity(),
      mentionedUser: mentionedUser?.toEntity(),
    );
  }
}

extension ListChildPostCommentResponseX on List<ChildPostCommentResponse> {
  List<Comment> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
