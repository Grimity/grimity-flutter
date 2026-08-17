// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'following_feed_response.dart';

part 'following_feeds_response.freezed.dart';
part 'following_feeds_response.g.dart';

@Freezed()
abstract class FollowingFeedsResponse with _$FollowingFeedsResponse {
  const factory FollowingFeedsResponse({
    required String? nextCursor,
    required List<FollowingFeedResponse> feeds,
  }) = _FollowingFeedsResponse;

  factory FollowingFeedsResponse.fromJson(Map<String, Object?> json) => _$FollowingFeedsResponseFromJson(json);
}
