import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/feed_api.dart';
import 'package:grimity/data/model/common/id_response.dart';
import 'package:grimity/data/model/feed/feed_today_popular_response.dart';
import 'package:grimity/data/model/feed/latest_feeds_response.dart';
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
  Future<Result<IdResponse>> createFeed(CreateFeedRequest request) async {
    try {
      final IdResponse response = await _feedAPI.createFeed(request);
      return Result.success(response);
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
  Future<Result<List<Feed>>> getTodayPopularFeeds() async {
    try {
      final List<FeedTodayPopularResponse> response = await _feedAPI.getTodayPopularFeeds();
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
}
