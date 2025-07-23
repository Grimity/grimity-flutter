import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_base_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'feed_ranking_response.freezed.dart';

part 'feed_ranking_response.g.dart';

@Freezed(copyWith: false)
abstract class FeedRankingResponse with _$FeedRankingResponse implements FeedBaseResponse {
  const FeedRankingResponse._();

  const factory FeedRankingResponse({
    required String id,
    required String title,
    String? thumbnail,
    required int likeCount,
    required int viewCount,
    required bool isLike,
    required UserBaseResponse author,
  }) = _FeedRankingResponse;

  factory FeedRankingResponse.fromJson(Map<String, dynamic> json) => _$FeedRankingResponseFromJson(json);
}

extension FeedRankingResponseX on FeedRankingResponse {
  Feed toEntity() {
    return Feed(
      id: id,
      title: title,
      thumbnail: thumbnail,
      likeCount: likeCount,
      viewCount: viewCount,
      isLike: isLike,
      author: author.toEntity(),
    );
  }
}

extension ListFeedRankingResponseX on List<FeedRankingResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
