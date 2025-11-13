import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/feed_api.dart';
import 'package:grimity/data/model/common/id_response.dart';
import 'package:grimity/data/model/feed/feed_detail_response.dart';
import 'package:grimity/data/model/feed/feed_rankings_response.dart';
import 'package:grimity/data/model/feed/following_feeds_response.dart';
import 'package:grimity/data/model/feed/latest_feeds_response.dart';
import 'package:grimity/data/model/feed/searched_feeds_response.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/repository/feed_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FeedRepository)
class FeedRepositoryImpl extends FeedRepository {
  final FeedAPI _feedAPI;

  FeedRepositoryImpl(this._feedAPI);

  @override
  Future<Result<String>> createFeed(CreateFeedRequest request) async {
    try {
      final IdResponse response = await _feedAPI.createFeed(request);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deleteFeeds(DeleteFeedsRequest request) async {
    try {
      await _feedAPI.deleteFeeds(request);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Feeds>> searchFeeds(SearchFeedRequest request) async {
    try {
      final SearchedFeedsResponse response = await _feedAPI.searchFeeds(
        request.cursor,
        request.size,
        request.keyword,
        request.sort,
      );
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Feeds>> getLatestFeeds(int? size, String? cursor) async {
    try {
      final LatestFeedsResponse response = await _feedAPI.getLatestFeeds(size, cursor);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<List<Feed>>> getFeedRankings({String? month, String? startDate, String? endDate}) async {
    try {
      if (month != null && month.isNotEmpty) {
        final FeedRankingsResponse response = await _feedAPI.getFeedRankings(month: month);
        return Result.success(response.toEntity());
      } else if (startDate != null && endDate != null) {
        final FeedRankingsResponse response = await _feedAPI.getFeedRankings(startDate: startDate, endDate: endDate);
        return Result.success(response.toEntity());
      } else {
        throw Exception('조회 기간 설정 오류');
      }
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Feeds>> getFollowingFeeds(int? size, String? cursor) async {
    try {
      final FollowingFeedsResponse response = await _feedAPI.getFollowingFeeds(size, cursor);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> updateFeed(String id, UpdateFeedRequest request) async {
    try {
      await _feedAPI.updateFeed(id, request);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deleteFeed(String id) async {
    try {
      await _feedAPI.deleteFeed(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Feed>> getFeedDetail(String id) async {
    try {
      final FeedDetailResponse response = await _feedAPI.getFeedDetail(id);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> likeFeed(String id) async {
    try {
      await _feedAPI.likeFeed(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> unlikeFeed(String id) async {
    try {
      await _feedAPI.unlikeFeed(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> saveFeed(String id) async {
    try {
      await _feedAPI.saveFeed(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> removeSavedFeed(String id) async {
    try {
      await _feedAPI.removeSavedFeed(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> incrementFeedViewCount(String id) async {
    try {
      await _feedAPI.incrementFeedViewCount(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
