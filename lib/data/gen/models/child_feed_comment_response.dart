// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_base_response.dart';

part 'child_feed_comment_response.freezed.dart';
part 'child_feed_comment_response.g.dart';

@Freezed()
abstract class ChildFeedCommentResponse with _$ChildFeedCommentResponse {
  const factory ChildFeedCommentResponse({
    required String id,
    required String content,
    required DateTime createdAt,
    required num likeCount,
    required UserBaseResponse writer,
    required UserBaseResponse? mentionedUser,
    required bool isLike,
  }) = _ChildFeedCommentResponse;

  factory ChildFeedCommentResponse.fromJson(Map<String, Object?> json) => _$ChildFeedCommentResponseFromJson(json);
}
