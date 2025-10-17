import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/data/model/album/album_base_response.dart';
import 'package:grimity/data/model/user/my_followers_response.dart';
import 'package:grimity/data/model/user/my_followings_response.dart';
import 'package:grimity/data/model/feed/my_like_feeds_response.dart';
import 'package:grimity/data/model/post/my_save_posts_response.dart';
import 'package:grimity/data/model/user/my_profile_response.dart';
import 'package:grimity/data/model/user/subscription_response.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'me_api.g.dart';

@injectable
@RestApi()
abstract class MeAPI {
  @factoryMethod
  factory MeAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _MeAPI;

  @GET('/me')
  Future<MyProfileResponse> getMyProfile();

  @PUT('/me')
  Future<void> updateUser(@Body() UpdateUserRequest request);

  @DELETE('/me')
  Future<void> deleteUser();

  @PUT('/me/image')
  Future<void> updateProfileImage(@Body() UpdateProfileImageRequestParam request);

  @DELETE('/me/image')
  Future<void> deleteProfileImage();

  @PUT('/me/background')
  Future<void> updateBackgroundImage(@Body() UpdateBackgroundImageRequestParam request);

  @DELETE('/me/background')
  Future<void> deleteBackgroundImage();

  @GET('/me/albums')
  Future<List<AlbumBaseResponse>> getMyAlbums();

  @GET('/me/followers')
  Future<MyFollowersResponse> getMyFollowers(@Query('size') int? size, @Query('cursor') String? cursor);

  @GET('/me/followings')
  Future<MyFollowingsResponse> getMyFollowings(@Query('size') int? size, @Query('cursor') String? cursor);

  @DELETE('/me/followers/{id}')
  Future<void> deleteFollowerById(@Path('id') String id);

  @GET('/me/like-feeds')
  Future<MyLikeFeedsResponse> getLikeFeeds(@Query('size') int? size, @Query('cursor') String? cursor);

  @GET('/me/save-feeds')
  Future<MyLikeFeedsResponse> getSaveFeeds(@Query('size') int? size, @Query('cursor') String? cursor);

  @GET('/me/save-posts')
  Future<MySavePostsResponse> getSavePosts(@Query('page') int page, @Query('size') int size);

  @GET('/me/subscribe')
  Future<SubscriptionResponse> getSubscription();

  @PUT('/me/subscribe')
  Future<void> updateSubscription(@Body() UpdateSubscriptionRequestParam request);
}
