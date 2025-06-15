import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/data/model/user/searched_users_response.dart';
import 'package:grimity/data/model/user/popular_user_response.dart';
import 'package:grimity/data/model/user/user_profile_response.dart';
import 'package:grimity/data/model/user/user_meta_response.dart';
import 'package:grimity/data/model/feed/user_feeds_response.dart';
import 'package:grimity/data/model/post/my_post_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'users_api.g.dart';

@prod
@injectable
@RestApi(baseUrl: AppConst.apiUrl)
abstract class UsersAPI {
  @factoryMethod
  factory UsersAPI(Dio dio) = _UsersAPI;

  @Headers({'withToken': "false"})
  @POST('/users/name-check')
  Future<void> nameCheck(@Body() Map<String, String> body);

  @GET('/users/search')
  Future<SearchedUsersResponse> searchUser(
    @Query('keyword') String keyword,
    @Query('cursor') String? cursor,
    @Query('size') int? size,
  );

  @GET('/users/popular')
  Future<List<PopularUserResponse>> getPopularUsers();

  @GET('/users/profile/{url}')
  Future<UserProfileResponse> getProfileByUrl(@Path('url') String url);

  @GET('/users/profile/{url}/meta')
  Future<UserMetaResponse> getMetaByUrl(@Path('url') String url);

  @GET('/users/{id}')
  Future<UserProfileResponse> getUserById(@Path('id') String id);

  @GET('/users/{id}/meta')
  Future<UserMetaResponse> getMeta(@Path('id') String id);

  @GET('/users/{id}/feeds')
  Future<UserFeedsResponse> getFeeds(
    @Path('id') String id,
    @Query('cursor') String? cursor,
    @Query('size') int? size,
    @Query('sort') SortType? sort,
    @Query('albumId') String? albumId,
  );

  @GET('/users/{id}/posts')
  Future<List<MyPostResponse>> getPosts(@Path('id') String id, @Query('page') int? page, @Query('size') int? size);
}
