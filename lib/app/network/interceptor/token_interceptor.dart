import 'package:dio/dio.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';

class TokenInterceptor extends QueuedInterceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      if (options.headers['withToken'] != 'false') {
        final token = await loadTokenUseCase.execute();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer ${token.accessToken}';
        }
      }

      options.headers.remove('withToken');

      handler.next(options);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }
}
