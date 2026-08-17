// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_meta_response.freezed.dart';
part 'feed_meta_response.g.dart';

@Freezed()
abstract class FeedMetaResponse with _$FeedMetaResponse {
  const factory FeedMetaResponse({
    required String id,
    required String title,
    required String thumbnail,
    required num likeCount,
    required num viewCount,
    required String content,
    required DateTime createdAt,
    required List<String> tags,
  }) = _FeedMetaResponse;

  factory FeedMetaResponse.fromJson(Map<String, Object?> json) => _$FeedMetaResponseFromJson(json);
}
