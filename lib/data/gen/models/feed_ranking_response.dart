// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_base_response.dart';

part 'feed_ranking_response.freezed.dart';
part 'feed_ranking_response.g.dart';

@Freezed()
abstract class FeedRankingResponse with _$FeedRankingResponse {
  const factory FeedRankingResponse({
    required String id,
    required String title,
    required String thumbnail,
    required num likeCount,
    required num viewCount,
    required bool isLike,
    required UserBaseResponse author,
  }) = _FeedRankingResponse;

  factory FeedRankingResponse.fromJson(Map<String, Object?> json) => _$FeedRankingResponseFromJson(json);
}
