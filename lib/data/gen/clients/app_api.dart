// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/app_version_response.dart';

part 'app_api.g.dart';

@RestApi()
abstract class AppApi {
  factory AppApi(Dio dio, {String? baseUrl}) = _AppApi;

  /// 헬스체크
  @GET('/health-check')
  Future<String> appHealthCheck();

  /// 앱용 버전 확인
  @GET('/app-version')
  Future<AppVersionResponse> appGetAppversion();
}
