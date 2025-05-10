import 'package:grimity/data/data_source/remote/feed_api.dart';
import 'package:grimity/data/model/feed/feed_today_popular_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@dev
@Injectable(as: FeedAPI)
class MockFeedAPI extends Mock implements FeedAPI {
  @override
  Future<List<FeedTodayPopularResponse>> getTodayPopularFeeds() async {
    return [];
  }
}
