import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 디버그 모드에서 HTTP 요청과 응답, 오류를 간단히 출력하는 인터셉터.
class DebugInterceptor extends Interceptor {
  const new({
    required this.request,
    required this.response,
  });

  final bool request;
  final bool response;

  static const _yellow = '\x1B[33m';
  static const _green = '\x1B[32m';
  static const _gray = '\x1B[90m';
  static const _red = '\x1B[31m';
  static const _reset = '\x1B[0m';

  /// 주어진 ANSI 색상으로 디버그용 메시지를 출력합니다.
  static void print(String messgae, String color) {
    if (kDebugMode) {
      debugPrint('$color$messgae$_reset');
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode && request) {
      final method = options.method;
      final data = options.data;
      final uri = options.uri;

      print('[요청] $method $uri', _yellow);

      // 본문 데이터가 있으면 이를 회색으로 출력.
      if (data != null) print(data, _gray);
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode && this.response) {
      final statusCode = response.statusCode;
      final data = response.data;
      final uri = response.requestOptions.uri;

      print('[응답] $statusCode $uri', _green);

      // 본문 데이터가 있으면 이를 회색으로 출력.
      if (data != null) print(data, _gray);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode && response) {
      final statusCode = err.response?.statusCode;
      final errorName = err.type.name;
      final uri = err.requestOptions.uri;

      print('[에러] ${statusCode ?? errorName} $uri', _red);
    }

    handler.next(err);
  }
}
