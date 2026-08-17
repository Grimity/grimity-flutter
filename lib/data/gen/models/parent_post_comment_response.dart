// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'child_post_comment_response.dart';
import 'user_base_response.dart';

part 'parent_post_comment_response.freezed.dart';
part 'parent_post_comment_response.g.dart';

@Freezed()
abstract class ParentPostCommentResponse with _$ParentPostCommentResponse {
  const factory ParentPostCommentResponse({
    required String id,
    required String content,
    required DateTime createdAt,
    required num likeCount,
    required bool isLike,

    /// null이면 익명화
    required UserBaseResponse? writer,
    required bool isDeleted,
    required List<ChildPostCommentResponse> childComments,
  }) = _ParentPostCommentResponse;

  factory ParentPostCommentResponse.fromJson(Map<String, Object?> json) => _$ParentPostCommentResponseFromJson(json);
}
