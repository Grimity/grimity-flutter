import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed_comments/feed_comment_base_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/comment.dart';

part 'child_feed_comment_response.freezed.dart';

part 'child_feed_comment_response.g.dart';

@Freezed(copyWith: false)
abstract class ChildFeedCommentResponse with _$ChildFeedCommentResponse implements FeedCommentBaseResponse {
  const factory ChildFeedCommentResponse({
    required String id,
    required String content,
    required DateTime createdAt,
    required int likeCount,
    required bool isLike,
    required UserBaseResponse writer,
    UserBaseResponse? mentionedUser,
  }) = _ChildFeedCommentResponse;

  factory ChildFeedCommentResponse.fromJson(Map<String, dynamic> json) => _$ChildFeedCommentResponseFromJson(json);
}

extension ChildFeedCommentResponseX on ChildFeedCommentResponse {
  Comment toEntity() {
    return Comment(
      id: id,
      content: content,
      createdAt: createdAt,
      likeCount: likeCount,
      isLike: isLike,
      writer: writer.toEntity(),
      mentionedUser: mentionedUser?.toEntity(),
    );
  }
}

extension ListChildFeedCommentResponseX on List<ChildFeedCommentResponse> {
  List<Comment> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
