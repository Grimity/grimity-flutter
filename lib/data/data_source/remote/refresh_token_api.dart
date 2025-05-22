import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/data/model/auth/refresh_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'refresh_token_api.g.dart';

@prod
@injectable
@RestApi(baseUrl: AppConst.apiUrl)
abstract class RefreshTokenAPI {
  @factoryMethod
  factory RefreshTokenAPI(@Named('refresh') Dio dio) = _RefreshTokenAPI;

  @GET('/auth/refresh')
  Future<RefreshResponse> refresh(
    @Header('grimity-app-model') String appModel,
    @Header('grimity-app-device') String appDevice,
  );
}
