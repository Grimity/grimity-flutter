import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed_comments/child_feed_comment_response.dart';
import 'package:grimity/data/model/feed_comments/feed_comment_base_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/comment.dart';

part 'parent_feed_comment_response.freezed.dart';

part 'parent_feed_comment_response.g.dart';

@Freezed(copyWith: false)
abstract class ParentFeedCommentResponse with _$ParentFeedCommentResponse implements FeedCommentBaseResponse {
  const factory ParentFeedCommentResponse({
    required String id,
    required String content,
    required DateTime createdAt,
    required int likeCount,
    required bool isLike,
    required UserBaseResponse writer,
    required List<ChildFeedCommentResponse> childComments,
  }) = _ParentFeedCommentResponse;

  factory ParentFeedCommentResponse.fromJson(Map<String, dynamic> json) => _$ParentFeedCommentResponseFromJson(json);
}

extension ParentFeedCommentResponseX on ParentFeedCommentResponse {
  Comment toEntity() {
    return Comment(
      id: id,
      content: content,
      createdAt: createdAt,
      likeCount: likeCount,
      isLike: isLike,
      writer: writer.toEntity(),
      childComments: childComments.toEntity(),
    );
  }
}

extension ListCParentFeedCommentResponseX on List<ParentFeedCommentResponse> {
  List<Comment> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
