// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'album_base_response.dart';
import 'user_base_with_blocked_response.dart';

part 'feed_detail_response.freezed.dart';
part 'feed_detail_response.g.dart';

@Freezed()
abstract class FeedDetailResponse with _$FeedDetailResponse {
  const factory FeedDetailResponse({
    required String id,
    required String title,
    required String thumbnail,
    required num likeCount,
    required num viewCount,
    required List<String> cards,
    required DateTime createdAt,
    required String content,
    required List<String> tags,
    required bool isLike,
    required bool isSave,
    required num commentCount,
    required AlbumBaseResponse? album,
    required UserBaseWithBlockedResponse author,
  }) = _FeedDetailResponse;

  factory FeedDetailResponse.fromJson(Map<String, Object?> json) => _$FeedDetailResponseFromJson(json);
}
