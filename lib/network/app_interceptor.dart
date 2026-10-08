import 'package:dio/dio.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_secure_storage.dart';
import 'package:grimity/util/app_device.dart';

/// API 요청의 인증 헤더와 토큰 갱신을 처리하는 앱 공통 인터셉터.
class AppInterceptor extends QueuedInterceptor {
  /// 인증 토큰을 첨부하지 않는 공개 API 경로 목록.
  static const _publicPaths = <String>{
    '/auth/login',
    '/auth/register',
    '/users/name-check',
    '/health-check',
    '/app-version',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final isPublicPath = _publicPaths.contains(options.uri.path);
    final needsToken = options.headers['withToken'] != 'false' && !isPublicPath;

    // 공개 경로 또는 `withToken` 헤더가 문자열 `false`인 요청을
    // 제외하고 저장된 액세스 토큰을 Bearer 인증 헤더에 추가합니다.
    if (needsToken) {
      final accessToken = await AppSecureStorage.accessToken.get();

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      } else {
        return handler.reject(
          .new(
            requestOptions: options,
            response: .new(requestOptions: options, statusCode: 401),
          ),
        );
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;

    // 로그인 등 공개 요청의 실패에는 기존 세션의 토큰 갱신을 시도하지 않습니다.
    if (_publicPaths.contains(err.requestOptions.uri.path) || err.requestOptions.headers['withToken'] == 'false') {
      return handler.next(err);
    }

    // 401 에러일 경우 토큰 리프레시 시도.
    if (response != null && response.statusCode == 401) {
      try {
        // 저장된 토큰 가져오기.
        final currentToken = await AppSecureStorage.accessToken.get();
        if (currentToken == null) {
          return handler.next(err);
        }

        // 토큰 리프레시 시도.
        final model = (await AppDevice.info).model;
        final result = await GetAuthRefresh(grimityAppModel: model).request();

        // 새로운 토큰 저장.
        await AppSecureStorage.accessToken.set(result.accessToken);
        await AppSecureStorage.refreshToken.set(result.refreshToken);

        // 새로운 토큰으로 기존 요청 재시도.
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer ${result.accessToken}';

        return handler.resolve(await Dio().fetch(options));
      } catch (e) {
        // 토큰 리프레시 실패 시 기존의 토큰들 모두 삭제.
        await AppSecureStorage.accessToken.delete();
        await AppSecureStorage.refreshToken.delete();

        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
