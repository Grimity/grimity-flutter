import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/data/model/common/id_response.dart';
import 'package:grimity/data/model/feed/feed_rankings_response.dart';
import 'package:grimity/data/model/feed/latest_feeds_response.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'feed_api.g.dart';

@injectable
@RestApi()
abstract class FeedAPI {
  @factoryMethod
  factory FeedAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _FeedAPI;

  @POST('/feeds')
  Future<IdResponse> createFeed(@Body() CreateFeedRequest request);

  @GET('/feeds/latest')
  Future<LatestFeedsResponse> getLatestFeeds(@Query('size') int? size, @Query('cursor') String? cursor);

  @GET('/feeds/rankings')
  Future<FeedRankingsResponse> getFeedRankings({
    @Query('month') String? month,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  });

  @PUT('/feeds/{id}/like')
  Future<void> likeFeed(@Path('id') String id);

  @DELETE('/feeds/{id}/like')
  Future<void> unlikeFeed(@Path('id') String id);

  @PUT('/feeds/{id}/save')
  Future<void> saveFeed(@Path('id') String id);

  @DELETE('/feeds/{id}/save')
  Future<void> removeSavedFeed(@Path('id') String id);
}
