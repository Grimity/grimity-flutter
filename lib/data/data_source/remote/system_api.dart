import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/data/model/system/app_version_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'system_api.g.dart';

@injectable
@RestApi()
abstract class SystemAPI {
  @factoryMethod
  factory SystemAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _SystemAPI;

  @GET('/health-check')
  Future<void> healthCheck();

  @GET('/app-version')
  Future<AppVersionResponse> getAppVersion();
}
