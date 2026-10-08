import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:grimity/network/app_interceptor.dart';

/// 앱의 공통 HTTP 설정과 실행 모드별 클라이언트를 관리합니다.
abstract class AppNetwork {
  static final _releaseDio = createDio('https://api.grimity.com');
  static final _debugDio = _releaseDio; // TODO: 추후 구현

  /// 디버그 모드에서는 개발 서버, 그 외에는 운영 서버 클라이언트를 반환합니다.
  static Dio get dio => kDebugMode ? _debugDio : _releaseDio;

  /// 주어진 URL에 대한 새 HTTP 클라이언트를 생성합니다.
  static Dio createDio(String baseUrl) {
    final dio = Dio();

    dio.options = .new(
      responseType: .json,
      baseUrl: baseUrl,
      contentType: Headers.jsonContentType,
      connectTimeout: .new(seconds: 15),
      receiveTimeout: .new(seconds: 15),
    );

    dio.interceptors.add(AppInterceptor());

    return dio;
  }
}
