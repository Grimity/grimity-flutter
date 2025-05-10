import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_base_response.dart';
import 'package:grimity/data/model/user/user_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'feed_response.freezed.dart';
part 'feed_response.g.dart';

@Freezed(copyWith: false)
abstract class FeedResponse with _$FeedResponse implements FeedBaseResponse {
  const FeedResponse._();

  const factory FeedResponse({
    required String id,
    required String title,
    String? thumbnail,
    required List<String> cards,
    required DateTime createdAt,
    required int viewCount,
    required int likeCount,
    required String content,
    required List<String> tags,
    required UserResponse author,
  }) = _FeedResponse;

  factory FeedResponse.fromJson(Map<String, dynamic> json) => _$FeedResponseFromJson(json);
}

extension FeedResponseX on FeedResponse {
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
    );
  }
}

extension ListFeedResponseX on List<FeedResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
