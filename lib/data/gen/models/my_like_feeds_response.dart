// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'my_like_feed_response.dart';

part 'my_like_feeds_response.freezed.dart';
part 'my_like_feeds_response.g.dart';

@Freezed()
abstract class MyLikeFeedsResponse with _$MyLikeFeedsResponse {
  const factory MyLikeFeedsResponse({
    required String? nextCursor,
    required List<MyLikeFeedResponse> feeds,
  }) = _MyLikeFeedsResponse;

  factory MyLikeFeedsResponse.fromJson(Map<String, Object?> json) => _$MyLikeFeedsResponseFromJson(json);
}
