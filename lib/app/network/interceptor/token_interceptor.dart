import 'dart:async';

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
        } else {
          return handler.reject(
            DioException(requestOptions: options, response: Response(requestOptions: options, statusCode: 401)),
          );
        }
      }

      options.headers.remove('withToken');

      handler.next(options);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;

    // 401 에러일 경우 토큰 리프레시 시도
    if (response != null && response.statusCode == 401) {
      try {
        // 저장된 토큰 가져오기
        final currentToken = await loadTokenUseCase.execute();
        if (currentToken == null) {
          return handler.next(err);
        }

        // 토큰 리프레시 시도
        final result = await refreshTokenUseCase.execute();
        if (result.isSuccess) {
          final refreshedToken = result.data;

          // 새로운 토큰 저장
          await updateTokenUseCase.execute(refreshedToken);

          // 새로운 토큰으로 기존 요청 재시도
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer ${refreshedToken.accessToken}';

          final retryResponse = await _retry(err);

          return handler.resolve(retryResponse);
        } else {
          // 토큰 리프레시 실패, 저장된 토큰 삭제
          await removeTokenUseCase.execute();
          return handler.next(err);
        }
      } catch (e) {
        return handler.next(err);
      }
    } else {
      return handler.next(err);
    }
  }

  // 요청 재시도 메소드
  Future<Response<dynamic>> _retry(DioException err) async {
    return Dio().fetch<dynamic>(err.requestOptions);
  }
}
