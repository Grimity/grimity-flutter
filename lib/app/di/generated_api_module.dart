import 'package:dio/dio.dart';
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/data/gen/clients/auth_api.dart';
import 'package:injectable/injectable.dart';

@module
abstract class GeneratedApiModule {
  @lazySingleton
  RestClient restClient(Dio dio, @Named('baseUrl') String baseUrl) => RestClient(dio, baseUrl: baseUrl);

  @Named('refreshAuthApi')
  @lazySingleton
  AuthApi refreshAuthApi(@Named('refresh') Dio dio, @Named('baseUrl') String baseUrl) => AuthApi(dio, baseUrl: baseUrl);
}
