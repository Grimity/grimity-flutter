import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_base_response.dart';
import 'package:grimity/data/model/user/user_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'feed_today_popular_response.freezed.dart';
part 'feed_today_popular_response.g.dart';

@Freezed(copyWith: false)
abstract class FeedTodayPopularResponse with _$FeedTodayPopularResponse implements FeedBaseResponse {
  const FeedTodayPopularResponse._();

  const factory FeedTodayPopularResponse({
    required String id,
    required String title,
    String? thumbnail,
    required DateTime createdAt,
    required int viewCount,
    required int likeCount,
    required bool isLike,
    required UserResponse author,
  }) = _FeedTodayPopularResponse;

  factory FeedTodayPopularResponse.fromJson(Map<String, dynamic> json) => _$FeedTodayPopularResponseFromJson(json);
}

extension FeedTodayPopularResponseX on FeedTodayPopularResponse {
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

extension ListFeedTodayPopularResponseX on List<FeedTodayPopularResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
