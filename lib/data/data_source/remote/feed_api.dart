import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/data/model/feed/feed_today_popular_response.dart';
import 'package:grimity/data/model/feed/latest_feeds_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'feed_api.g.dart';

@prod
@injectable
@RestApi(baseUrl: AppConst.apiUrl)
abstract class FeedAPI {
  @factoryMethod
  factory FeedAPI(Dio dio) = _FeedAPI;

  @GET('/feeds/latest')
  Future<LatestFeedsResponse> getLatestFeeds(@Query('size') int? size, @Query('cursor') String? cursor);

  @GET('/feeds/today-popular')
  Future<List<FeedTodayPopularResponse>> getTodayPopularFeeds();
}
