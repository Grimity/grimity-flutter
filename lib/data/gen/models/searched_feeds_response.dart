// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'searched_feed_response.dart';

part 'searched_feeds_response.freezed.dart';
part 'searched_feeds_response.g.dart';

@Freezed()
abstract class SearchedFeedsResponse with _$SearchedFeedsResponse {
  const factory SearchedFeedsResponse({
    required String? nextCursor,
    required List<SearchedFeedResponse> feeds,
  }) = _SearchedFeedsResponse;

  factory SearchedFeedsResponse.fromJson(Map<String, Object?> json) => _$SearchedFeedsResponseFromJson(json);
}
