import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/gen/models/create_feed_request.dart' as generated;
import 'package:grimity/data/gen/models/delete_feeds_request.dart' as generated;
import 'package:grimity/data/gen/models/feed_search_sort.dart' as generated;
import 'package:grimity/data/gen/models/update_feed_request.dart' as generated;
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/data/mapper/generated_feed_mapper.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FeedService {
  final RestClient _client;

  FeedService(this._client);

  Future<Result<String>> createFeed(CreateFeedRequest request) async {
    try {
      final response = await _client.feeds.feedCreate(body: generated.CreateFeedRequest.fromJson(request.toJson()));
      return Result.success(response.id);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deleteFeeds(DeleteFeedsRequest request) async {
    try {
      await _client.feeds.feedDeleteMany(body: generated.DeleteFeedsRequest.fromJson(request.toJson()));
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Feeds>> searchFeeds(SearchFeedRequest request) async {
    try {
      final response = await _client.feeds.feedSearch(
        cursor: request.cursor,
        size: request.size,
        keyword: request.keyword,
        sort: generated.FeedSearchSort.fromJson(request.sort.name),
      );
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Feeds>> getLatestFeeds(int? size, String? cursor) async {
    try {
      final response = await _client.feeds.feedGetFeeds(size: size, cursor: cursor);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<List<Feed>>> getFeedRankings({String? month, String? startDate, String? endDate}) async {
    try {
      if (month != null && month.isNotEmpty) {
        final response = await _client.feeds.feedGetFeedRanks(month: month);
        return Result.success(response.toEntity());
      } else if (startDate != null && endDate != null) {
        final response = await _client.feeds.feedGetFeedRanks(startDate: startDate, endDate: endDate);
        return Result.success(response.toEntity());
      } else {
        throw Exception('조회 기간 설정 오류');
      }
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Feeds>> getFollowingFeeds(int? size, String? cursor) async {
    try {
      final response = await _client.feeds.feedGetFollowingFeeds(size: size, cursor: cursor);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> updateFeed(String id, UpdateFeedRequest request) async {
    try {
      await _client.feeds.feedUpdate(id: id, body: generated.UpdateFeedRequest.fromJson(request.toJson()));
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deleteFeed(String id) async {
    try {
      await _client.feeds.feedDelete(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Feed>> getFeedDetail(String id) async {
    try {
      final response = await _client.feeds.feedGetFeed(id: id);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> likeFeed(String id) async {
    try {
      await _client.feeds.feedLike(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> unlikeFeed(String id) async {
    try {
      await _client.feeds.feedUnlike(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> saveFeed(String id) async {
    try {
      await _client.feeds.feedSave(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> removeSavedFeed(String id) async {
    try {
      await _client.feeds.feedUnsave(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> incrementFeedViewCount(String id) async {
    try {
      await _client.feeds.feedView(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
