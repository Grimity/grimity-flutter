// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_base_response.dart';

part 'my_like_feed_response.freezed.dart';
part 'my_like_feed_response.g.dart';

@Freezed()
abstract class MyLikeFeedResponse with _$MyLikeFeedResponse {
  const factory MyLikeFeedResponse({
    required String id,
    required String title,
    required String thumbnail,
    required num likeCount,
    required num viewCount,
    required List<String> cards,
    required num commentCount,

    /// 내가 좋아요/저장 한 시간
    required DateTime createdAt,
    required UserBaseResponse author,
  }) = _MyLikeFeedResponse;

  factory MyLikeFeedResponse.fromJson(Map<String, Object?> json) => _$MyLikeFeedResponseFromJson(json);
}
