import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_ranking_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'feed_rankings_response.freezed.dart';

part 'feed_rankings_response.g.dart';

@Freezed(copyWith: false)
abstract class FeedRankingsResponse with _$FeedRankingsResponse {
  const FeedRankingsResponse._();

  const factory FeedRankingsResponse({required List<FeedRankingResponse> feeds}) = _FeedRankingsResponse;

  factory FeedRankingsResponse.fromJson(Map<String, dynamic> json) => _$FeedRankingsResponseFromJson(json);
}

extension FeedRankingsResponseX on FeedRankingsResponse {
  List<Feed> toEntity() {
    return feeds.toEntity();
  }
}
