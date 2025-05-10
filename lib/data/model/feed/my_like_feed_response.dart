import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_base_response.dart';
import 'package:grimity/data/model/user/user_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'my_like_feed_response.freezed.dart';
part 'my_like_feed_response.g.dart';

@Freezed(copyWith: false)
abstract class MyLikeFeedResponse with _$MyLikeFeedResponse implements FeedBaseResponse {
  const MyLikeFeedResponse._();

  const factory MyLikeFeedResponse({
    required String id,
    required String title,
    String? thumbnail,
    required List<String> cards,
    required int likeCount,
    required int viewCount,
    required int commentCount,
    required DateTime createdAt,
    required UserResponse author,
  }) = _MyLikeFeedResponse;

  factory MyLikeFeedResponse.fromJson(Map<String, dynamic> json) => _$MyLikeFeedResponseFromJson(json);
}

extension MyLikeFeedResponseX on MyLikeFeedResponse {
  Feed toEntity() {
    return Feed(
      id: id,
      title: title,
      thumbnail: thumbnail,
      cards: cards,
      likeCount: likeCount,
      viewCount: viewCount,
      commentCount: commentCount,
      createdAt: createdAt,
      author: author.toEntity(),
    );
  }
}

extension ListMyLikeFeedResponseX on List<MyLikeFeedResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
