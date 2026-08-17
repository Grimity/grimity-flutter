// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_base_response.dart';

part 'searched_feed_response.freezed.dart';
part 'searched_feed_response.g.dart';

@Freezed()
abstract class SearchedFeedResponse with _$SearchedFeedResponse {
  const factory SearchedFeedResponse({
    required String id,
    required String title,
    required String thumbnail,
    required num likeCount,
    required num viewCount,
    required List<String> cards,
    required DateTime createdAt,
    required String content,
    required List<String> tags,
    required UserBaseResponse author,
    required num commentCount,
    required bool isLike,
  }) = _SearchedFeedResponse;

  factory SearchedFeedResponse.fromJson(Map<String, Object?> json) => _$SearchedFeedResponseFromJson(json);
}
