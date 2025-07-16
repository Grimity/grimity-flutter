import 'package:dio/dio.dart';
import 'package:grimity/app/di/api_module.dart';
import 'package:grimity/app/network/interceptor/refresh_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

const Duration connectionTimeOutMls = Duration(milliseconds: 15000);
const Duration readTimeOutMls = Duration(milliseconds: 15000);

/// 토큰 리프레시용 Dio
@module
abstract class RefreshDioProvider {
  @lazySingleton
  @Named('refresh')
  Dio refreshDio(ApiUrlProvider apiUrlProvider) {
    final Dio dio = Dio();

    dio.options = BaseOptions(
      responseType: ResponseType.json,
      baseUrl: apiUrlProvider.apiUrl,
      contentType: Headers.jsonContentType,
      connectTimeout: connectionTimeOutMls,
      receiveTimeout: readTimeOutMls,
    );

    dio.interceptors.add(TalkerDioLogger(talker: TalkerFlutter.init()));
    dio.interceptors.add(RefreshInterceptor());

    return dio;
  }
}
