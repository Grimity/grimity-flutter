// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'latest_feed_response.dart';

part 'latest_feeds_response.freezed.dart';
part 'latest_feeds_response.g.dart';

@Freezed()
abstract class LatestFeedsResponse with _$LatestFeedsResponse {
  const factory LatestFeedsResponse({
    required String? nextCursor,
    required List<LatestFeedResponse> feeds,
  }) = _LatestFeedsResponse;

  factory LatestFeedsResponse.fromJson(Map<String, Object?> json) => _$LatestFeedsResponseFromJson(json);
}
