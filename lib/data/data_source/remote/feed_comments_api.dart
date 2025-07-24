import 'package:dio/dio.dart';
import 'package:grimity/data/model/feed_comments/parent_feed_comment_response.dart';
import 'package:grimity/domain/dto/feed_comments_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'feed_comments_api.g.dart';

@injectable
@RestApi()
abstract class FeedCommentsAPI {
  @factoryMethod
  factory FeedCommentsAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _FeedCommentsAPI;

  @POST('/feed-comments')
  Future<void> createFeedComment(@Body() CreateFeedCommentRequest request);

  @GET('/feed-comments')
  Future<List<ParentFeedCommentResponse>> getFeedComments(@Query('feedId') String feedId);

  @DELETE('/feed-comments/{id}')
  Future<void> deleteFeedComment(@Path('id') String id);

  @PUT('/feed-comments/{id}/like')
  Future<void> likeFeedComment(@Path('id') String id);

  @DELETE('/feed-comments/{id}/like')
  Future<void> unlikeFeedComment(@Path('id') String id);
}
