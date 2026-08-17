import 'package:grimity/data/gen/models/feed_detail_response.dart' as generated;
import 'package:grimity/data/gen/models/feed_rankings_response.dart' as generated;
import 'package:grimity/data/gen/models/following_feeds_response.dart' as generated;
import 'package:grimity/data/gen/models/latest_feeds_response.dart' as generated;
import 'package:grimity/data/gen/models/searched_feeds_response.dart' as generated;
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/data/mapper/json_normalizer.dart';

Map<String, dynamic> _json(Map<String, Object?> value) => normalizeJsonMap(value);

extension GeneratedLatestFeedsResponseMapper on generated.LatestFeedsResponse {
  Feeds toEntity() => Feeds.fromJson(_json(toJson()));
}

extension GeneratedFollowingFeedsResponseMapper on generated.FollowingFeedsResponse {
  Feeds toEntity() => Feeds.fromJson(_json(toJson()));
}

extension GeneratedSearchedFeedsResponseMapper on generated.SearchedFeedsResponse {
  Feeds toEntity() => Feeds.fromJson(_json(toJson()));
}

extension GeneratedFeedRankingsResponseMapper on generated.FeedRankingsResponse {
  List<Feed> toEntity() => feeds.map((feed) => Feed.fromJson(_json(feed.toJson()))).toList();
}

extension GeneratedFeedDetailResponseMapper on generated.FeedDetailResponse {
  Feed toEntity() => Feed.fromJson(_json(toJson()));
}
