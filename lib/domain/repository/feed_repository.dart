import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/feeds.dart';

abstract class FeedRepository {
  Future<Result<Feeds>> getLatestFeeds(int? size, String? cursor);
  Future<Result<List<Feed>>> getTodayPopularFeeds();
  Future<Result<void>> likeFeed(String id);
  Future<Result<void>> unlikeFeed(String id);
  Future<Result<void>> saveFeed(String id);
  Future<Result<void>> removeSavedFeed(String id);
}
