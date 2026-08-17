import 'package:grimity/data/gen/models/parent_feed_comment_response.dart' as generated;
import 'package:grimity/data/gen/models/parent_post_comment_response.dart' as generated;
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/data/mapper/json_normalizer.dart';

Map<String, dynamic> _json(Map<String, Object?> value) => normalizeJsonMap(value);

extension GeneratedParentFeedCommentResponsesMapper on List<generated.ParentFeedCommentResponse> {
  List<Comment> toEntity() => map((comment) => Comment.fromJson(_json(comment.toJson()))).toList();
}

extension GeneratedParentPostCommentResponsesMapper on List<generated.ParentPostCommentResponse> {
  List<Comment> toEntity() => map((comment) => Comment.fromJson(_json(comment.toJson()))).toList();
}
