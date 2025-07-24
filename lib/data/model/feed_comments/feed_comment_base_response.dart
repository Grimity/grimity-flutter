import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/comment.dart';

part 'feed_comment_base_response.freezed.dart';

part 'feed_comment_base_response.g.dart';

@Freezed(copyWith: false)
abstract class FeedCommentBaseResponse with _$FeedCommentBaseResponse {
  const factory FeedCommentBaseResponse({
    required String id,
    required String content,
    required DateTime createdAt,
    required int likeCount,
    required bool isLike,
    required UserBaseResponse writer,
  }) = _FeedCommentBaseResponse;

  factory FeedCommentBaseResponse.fromJson(Map<String, dynamic> json) => _$FeedCommentBaseResponseFromJson(json);
}

extension FeedCommentBaseResponseX on FeedCommentBaseResponse {
  Comment toEntity() {
    return Comment(
      id: id,
      content: content,
      createdAt: createdAt,
      likeCount: likeCount,
      isLike: isLike,
      writer: writer.toEntity(),
    );
  }
}

extension ListFeedCommentBaseResponseX on List<FeedCommentBaseResponse> {
  List<Comment> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
