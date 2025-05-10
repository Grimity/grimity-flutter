import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/feed_api.dart';
import 'package:grimity/data/model/feed/feed_today_popular_response.dart';
import 'package:grimity/data/model/feed/latest_feeds_response.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/repository/feed_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FeedRepository)
class FeedRepositoryImpl extends FeedRepository {
  final FeedAPI _feedAPI;

  FeedRepositoryImpl(this._feedAPI);

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
}
