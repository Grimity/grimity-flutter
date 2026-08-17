// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_comment_request.freezed.dart';
part 'create_post_comment_request.g.dart';

@Freezed()
abstract class CreatePostCommentRequest with _$CreatePostCommentRequest {
  const factory CreatePostCommentRequest({
    required String postId,
    required String content,

    /// 부모 댓글의 UUID
    String? parentCommentId,

    /// 언급된 사용자의 UUID
    String? mentionedUserId,
  }) = _CreatePostCommentRequest;

  factory CreatePostCommentRequest.fromJson(Map<String, Object?> json) => _$CreatePostCommentRequestFromJson(json);
}
