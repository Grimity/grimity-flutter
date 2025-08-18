import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_comments_request_params.freezed.dart';

part 'post_comments_request_params.g.dart';

@freezed
abstract class CreatePostCommentRequest with _$CreatePostCommentRequest {
  factory CreatePostCommentRequest({
    required String postId,
    String? parentCommentId,
    required String content,
    String? mentionedUserId,
  }) = _CreatePostCommentRequest;

  factory CreatePostCommentRequest.fromJson(Map<String, dynamic> json) => _$CreatePostCommentRequestFromJson(json);
}
