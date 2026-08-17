// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'feed_comment_with_writer_response.dart';
import 'user_base_response.dart';

part 'following_feed_response.freezed.dart';
part 'following_feed_response.g.dart';

@Freezed()
abstract class FollowingFeedResponse with _$FollowingFeedResponse {
  const factory FollowingFeedResponse({
    required String id,
    required String title,
    required String thumbnail,
    required num likeCount,
    required num viewCount,
    required List<String> cards,
    required DateTime createdAt,
    required String content,
    required List<String> tags,
    required num commentCount,
    required bool isLike,
    required bool isSave,
    required FeedCommentWithWriterResponse? comment,
    required UserBaseResponse author,
  }) = _FollowingFeedResponse;

  factory FollowingFeedResponse.fromJson(Map<String, Object?> json) => _$FollowingFeedResponseFromJson(json);
}
