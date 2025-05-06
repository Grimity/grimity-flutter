import 'package:dio/dio.dart';

class TokenInterceptor extends QueuedInterceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);

    handler.next(options);
  }
}
