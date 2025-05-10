import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/data/model/auth/login_response.dart';
import 'package:grimity/domain/usecase/auth/login_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@prod
@injectable
@RestApi(baseUrl: AppConst.apiUrl)
abstract class AuthAPI {
  @factoryMethod
  factory AuthAPI(Dio dio) = _AuthAPI;

  @POST('/auth/login')
  @Headers({'withToken': "false"})
  Future<LoginResponse> login(@Body() LoginRequestParam request);
}
