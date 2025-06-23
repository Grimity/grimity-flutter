import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/data/model/user/my_followers_response.dart';
import 'package:grimity/data/model/user/my_followings_response.dart';
import 'package:grimity/data/model/user/my_profile_response.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'me_api.g.dart';

@prod
@injectable
@RestApi(baseUrl: AppConst.apiUrl)
abstract class MeAPI {
  @factoryMethod
  factory MeAPI(Dio dio) = _MeAPI;

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

  @GET('/me/followers')
  Future<MyFollowersResponse> getMyFollowers(@Query('size') int? size, @Query('cursor') String? cursor);

  @GET('/me/followings')
  Future<MyFollowingsResponse> getMyFollowings(@Query('size') int? size, @Query('cursor') String? cursor);

  @DELETE('/me/followings/{id}')
  Future<void> deleteFollowerById(@Path('id') String id);
}
