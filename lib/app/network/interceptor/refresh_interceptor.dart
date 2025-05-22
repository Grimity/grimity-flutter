import 'package:dio/dio.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';

class RefreshInterceptor extends QueuedInterceptor {
  RefreshInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await loadTokenUseCase.execute();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer ${token.refreshToken}';
      }

      handler.next(options);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }
}
