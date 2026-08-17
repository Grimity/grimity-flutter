// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_base_response.dart';

part 'feed_comment_with_writer_response.freezed.dart';
part 'feed_comment_with_writer_response.g.dart';

@Freezed()
abstract class FeedCommentWithWriterResponse with _$FeedCommentWithWriterResponse {
  const factory FeedCommentWithWriterResponse({
    required String id,
    required String content,
    required DateTime createdAt,
    required num likeCount,
    required UserBaseResponse writer,
  }) = _FeedCommentWithWriterResponse;

  factory FeedCommentWithWriterResponse.fromJson(Map<String, Object?> json) =>
      _$FeedCommentWithWriterResponseFromJson(json);
}
