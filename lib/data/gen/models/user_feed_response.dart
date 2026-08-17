// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_feed_response.freezed.dart';
part 'user_feed_response.g.dart';

@Freezed()
abstract class UserFeedResponse with _$UserFeedResponse {
  const factory UserFeedResponse({
    required String id,
    required String title,
    required String thumbnail,
    required num likeCount,
    required num viewCount,
    required List<String> cards,
    required DateTime createdAt,
    required num commentCount,
    required bool isLike,
  }) = _UserFeedResponse;

  factory UserFeedResponse.fromJson(Map<String, Object?> json) => _$UserFeedResponseFromJson(json);
}
