import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/post_type.enum.dart';

part 'post_comments_request_params.freezed.dart';

part 'post_comments_request_params.g.dart';

@freezed
abstract class CreatePostRequest with _$CreatePostRequest {
  factory CreatePostRequest({required String title, required String content, required PostType type}) =
      _CreatePostRequest;

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) => _$CreatePostRequestFromJson(json);
}

@freezed
abstract class UpdatePostWithIdRequestParam with _$UpdatePostWithIdRequestParam {
  const factory UpdatePostWithIdRequestParam({required String id, required CreatePostRequest param}) =
      _UpdatePostWithIdRequestParam;

  factory UpdatePostWithIdRequestParam.fromJson(Map<String, dynamic> json) =>
      _$UpdatePostWithIdRequestParamFromJson(json);
}

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
