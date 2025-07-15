import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/data/model/auth/login_response.dart';
import 'package:grimity/domain/dto/auth_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@injectable
@RestApi()
abstract class AuthAPI {
  @factoryMethod
  factory AuthAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _AuthAPI;

  @POST('/auth/login')
  @Headers({'withToken': "false"})
  Future<LoginResponse> login(
    @Header('grimity-app-model') String appModel,
    @Header('grimity-app-device') String appDevice,
    @Body() LoginRequestParam request,
  );

  @GET('/auth/logout')
  Future<void> logout(@Header('grimity-app-model') String appModel, @Header('grimity-app-device') String appDevice);

  @POST('/auth/register')
  @Headers({'withToken': "false"})
  Future<LoginResponse> register(
    @Header('grimity-app-model') String appModel,
    @Header('grimity-app-device') String appDevice,
    @Body() RegisterRequestParam request,
  );
}
