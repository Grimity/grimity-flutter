import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/app/config/app_const.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'users_api.g.dart';

@prod
@injectable
@RestApi(baseUrl: AppConst.apiUrl)
abstract class UsersAPI {
  @factoryMethod
  factory UsersAPI(Dio dio) = _UsersAPI;

  @POST('/users/name-check')
  Future<void> nameCheck(@Body() Map<String, String> body);
}
