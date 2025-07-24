import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_comments_request_params.freezed.dart';

part 'feed_comments_request_params.g.dart';

@freezed
abstract class CreateFeedCommentRequest with _$CreateFeedCommentRequest {
  const factory CreateFeedCommentRequest({
    required String feedId,
    required String parentCommentId,
    required String content,
    required String mentionedUserId,
  }) = _CreateFeedCommentRequest;

  factory CreateFeedCommentRequest.fromJson(Map<String, dynamic> json) => _$CreateFeedCommentRequestFromJson(json);
}
