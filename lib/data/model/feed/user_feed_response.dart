import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_base_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'user_feed_response.freezed.dart';
part 'user_feed_response.g.dart';

@Freezed(copyWith: false)
abstract class UserFeedResponse with _$UserFeedResponse implements FeedBaseResponse {
  const UserFeedResponse._();

  const factory UserFeedResponse({
    required String id,
    required String title,
    String? thumbnail,
    required List<String> cards,
    required DateTime createdAt,
    required int viewCount,
    required int likeCount,
    required int commentCount,
  }) = _UserFeedResponse;

  factory UserFeedResponse.fromJson(Map<String, dynamic> json) => _$UserFeedResponseFromJson(json);
}

extension UserFeedResponseX on UserFeedResponse {
  Feed toEntity() {
    return Feed(
      id: id,
      title: title,
      thumbnail: thumbnail,
      cards: cards,
      createdAt: createdAt,
      viewCount: viewCount,
      likeCount: likeCount,
      commentCount: commentCount,
    );
  }
}

extension ListUserFeedResponseX on List<UserFeedResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
