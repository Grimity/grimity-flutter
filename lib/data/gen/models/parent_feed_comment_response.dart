// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'child_feed_comment_response.dart';
import 'user_base_response.dart';

part 'parent_feed_comment_response.freezed.dart';
part 'parent_feed_comment_response.g.dart';

@Freezed()
abstract class ParentFeedCommentResponse with _$ParentFeedCommentResponse {
  const factory ParentFeedCommentResponse({
    required String id,
    required String content,
    required DateTime createdAt,
    required num likeCount,
    required UserBaseResponse writer,
    required List<ChildFeedCommentResponse> childComments,
    required bool isLike,
  }) = _ParentFeedCommentResponse;

  factory ParentFeedCommentResponse.fromJson(Map<String, Object?> json) => _$ParentFeedCommentResponseFromJson(json);
}
