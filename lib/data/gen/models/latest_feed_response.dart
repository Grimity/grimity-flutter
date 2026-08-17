// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_base_response.dart';

part 'latest_feed_response.freezed.dart';
part 'latest_feed_response.g.dart';

@Freezed()
abstract class LatestFeedResponse with _$LatestFeedResponse {
  const factory LatestFeedResponse({
    required String id,
    required String title,
    required String thumbnail,
    required num likeCount,
    required num viewCount,
    required UserBaseResponse author,
    required DateTime createdAt,
    required bool isLike,
  }) = _LatestFeedResponse;

  factory LatestFeedResponse.fromJson(Map<String, Object?> json) => _$LatestFeedResponseFromJson(json);
}
