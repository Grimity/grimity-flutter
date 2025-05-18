import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_base_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'popular_feed_response.freezed.dart';
part 'popular_feed_response.g.dart';

@Freezed(copyWith: false)
abstract class PopularFeedResponse with _$PopularFeedResponse implements FeedBaseResponse {
  const PopularFeedResponse._();

  const factory PopularFeedResponse({
    required String id,
    required String title,
    String? thumbnail,
    required DateTime createdAt,
    required int viewCount,
    required int likeCount,
    required bool isLike,
    required UserBaseResponse author,
  }) = _PopularFeedResponse;

  factory PopularFeedResponse.fromJson(Map<String, dynamic> json) => _$PopularFeedResponseFromJson(json);
}

extension PopularFeedResponseX on PopularFeedResponse {
  Feed toEntity() {
    return Feed(
      id: id,
      title: title,
      thumbnail: thumbnail,
      createdAt: createdAt,
      viewCount: viewCount,
      likeCount: likeCount,
      isLike: isLike,
      author: author.toEntity(),
    );
  }
}

extension ListPopularFeedResponseX on List<PopularFeedResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
