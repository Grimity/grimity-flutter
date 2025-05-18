import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/data/model/user/my_profile_response.dart';
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
}
