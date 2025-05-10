import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_base_response.dart';
import 'package:grimity/data/model/user/user_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'latest_feed_response.freezed.dart';
part 'latest_feed_response.g.dart';

@Freezed(copyWith: false)
abstract class LatestFeedResponse with _$LatestFeedResponse implements FeedBaseResponse {
  const LatestFeedResponse._();

  const factory LatestFeedResponse({
    required String id,
    required String title,
    String? thumbnail,
    required int viewCount,
    required int likeCount,
    required UserResponse author,
    required DateTime createdAt,
    required bool isLike,
  }) = _LatestFeedResponse;

  factory LatestFeedResponse.fromJson(Map<String, dynamic> json) => _$LatestFeedResponseFromJson(json);
}

extension LatestFeedResponseX on LatestFeedResponse {
  Feed toEntity() {
    return Feed(
      id: id,
      title: title,
      thumbnail: thumbnail,
      viewCount: viewCount,
      likeCount: likeCount,
      author: author.toEntity(),
      createdAt: createdAt,
      isLike: isLike,
    );
  }
}

extension ListLatestFeedResponseX on List<LatestFeedResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
