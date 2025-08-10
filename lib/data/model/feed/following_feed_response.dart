import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'following_feed_response.freezed.dart';
part 'following_feed_response.g.dart';

@Freezed(copyWith: false)
abstract class FollowingFeedResponse with _$FollowingFeedResponse implements FeedResponse {
  const FollowingFeedResponse._();

  const factory FollowingFeedResponse({
    required String id,
    required String title,
    String? thumbnail,
    required List<String> cards,
    required DateTime createdAt,
    required int viewCount,
    required int likeCount,
    required String content,
    required List<String> tags,
    required UserBaseResponse author,
    required int commentCount,
    required bool isLike,
    required bool isSave,
    Comment? comment,
  }) = _FollowingFeedResponse;

  factory FollowingFeedResponse.fromJson(Map<String, dynamic> json) => _$FollowingFeedResponseFromJson(json);
}

extension FollowingFeedResponseX on FollowingFeedResponse {
  Feed toEntity() {
    return Feed(
      id: id,
      title: title,
      thumbnail: thumbnail,
      cards: cards,
      createdAt: createdAt,
      viewCount: viewCount,
      likeCount: likeCount,
      content: content,
      tags: tags,
      author: author.toEntity(),
      commentCount: commentCount,
      isLike: isLike,
      isSave: isSave,
      comment: comment,
    );
  }
}

extension ListFollowingFeedResponseX on List<FollowingFeedResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
