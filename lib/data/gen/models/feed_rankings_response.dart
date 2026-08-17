// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'feed_ranking_response.dart';

part 'feed_rankings_response.freezed.dart';
part 'feed_rankings_response.g.dart';

@Freezed()
abstract class FeedRankingsResponse with _$FeedRankingsResponse {
  const factory FeedRankingsResponse({
    required List<FeedRankingResponse> feeds,
  }) = _FeedRankingsResponse;

  factory FeedRankingsResponse.fromJson(Map<String, Object?> json) => _$FeedRankingsResponseFromJson(json);
}
