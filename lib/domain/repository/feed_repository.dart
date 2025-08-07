import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/model/common/id_response.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/feeds.dart';

abstract class FeedRepository {
  Future<Result<IdResponse>> createFeed(CreateFeedRequest request);

  Future<Result<Feeds>> getLatestFeeds(int? size, String? cursor);

  Future<Result<List<Feed>>> getFeedRankings({String? month, String? startDate, String? endDate});

  Future<Result<Feeds>> getFollowingFeeds(int? size, String? cursor);

  Future<Result<void>> updateFeed(String id, UpdateFeedRequest request);

  Future<Result<void>> deleteFeed(String id);

  Future<Result<Feed>> getFeedDetail(String id);

  Future<Result<void>> likeFeed(String id);

  Future<Result<void>> unlikeFeed(String id);

  Future<Result<void>> saveFeed(String id);

  Future<Result<void>> removeSavedFeed(String id);
}
