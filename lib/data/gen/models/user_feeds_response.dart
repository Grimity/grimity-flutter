// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_feed_response.dart';

part 'user_feeds_response.freezed.dart';
part 'user_feeds_response.g.dart';

@Freezed()
abstract class UserFeedsResponse with _$UserFeedsResponse {
  const factory UserFeedsResponse({
    required String? nextCursor,
    required List<UserFeedResponse> feeds,
  }) = _UserFeedsResponse;

  factory UserFeedsResponse.fromJson(Map<String, Object?> json) => _$UserFeedsResponseFromJson(json);
}
