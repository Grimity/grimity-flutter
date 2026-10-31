// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:dio/dio.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_secure_storage.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/app/app_device.dart';

/// API 요청의 인증 헤더와 토큰 갱신을 처리하는 앱 공통 인터셉터.
class AuthInterceptor extends Interceptor {
  /// 인증 토큰을 첨부하지 않는 공개 API 경로 목록.
  static const publicPaths = <String>{
    '/auth/login',
    '/auth/register',
    '/users/name-check',
    '/health-check',
    '/app-version',
  };

  /// 토큰 갱신 후 재시도한 요청을 구분하는 키.
  static const _retriedKey = 'grimity.authRetried';

  /// 동시에 실패한 요청들이 함께 기다리는 토큰 갱신 작업.
  Future<void>? _refreshing;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!publicPaths.contains(options.uri.path)) {
      // 갱신 혹은 로그아웃 요청은 리프레시 토큰, 나머지는 액세스 토큰으로 인증.
      final usesRefreshToken = options.uri.path == '/auth/refresh' || options.uri.path == '/auth/logout';

      final token = usesRefreshToken
          ? await AppSecureStorage.refreshToken.get()
          : await AppSecureStorage.accessToken.get();

      if (token == null) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 401),
          ),
        );
      }

      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;

    // 인증 오류가 아니면 그대로 에러 전달.
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // 공개 API의 실패는 토큰 갱신 대상이 아님.
    if (publicPaths.contains(options.uri.path)) {
      return handler.next(err);
    }

    // 토큰 갱신 자체가 실패하면 다시 갱신하지 않음.
    if (options.uri.path == '/auth/refresh') {
      return handler.next(err);
    }

    // 이미 새 토큰으로 재시도했다면 여기서 종료.
    if (options.extra[_retriedKey] == true) {
      return handler.next(err);
    }

    try {
      final currentToken = await AppSecureStorage.accessToken.get();
      if (currentToken == null) return handler.next(err);

      // 다른 요청이 이미 토큰을 갱신했다면 현재 토큰으로 바로 재시도.
      if (options.headers['Authorization'] == 'Bearer $currentToken') {
        _refreshing ??= _refreshTokens();

        try {
          await _refreshing;
        } finally {
          _refreshing = null;
        }
      }

      // 기존 클라이언트의 인증·응답 처리 설정을 유지하여 한 번만 재시도.
      final retryOptions = options.copyWith(
        extra: {
          ...options.extra,
          _retriedKey: true,
        },
      );

      return handler.resolve(await Api.dio.fetch(retryOptions));
    } catch (_) {
      // 갱신 또는 재인증 실패 시 저장된 토큰 삭제.
      await AppSecureStorage.accessToken.delete();
      await AppSecureStorage.refreshToken.delete();
      AppUser.status = .unauth;
    }

    handler.next(err);
  }

  /// 토큰을 갱신하고 새 액세스·리프레시 토큰을 저장합니다.
  Future<void> _refreshTokens() async {
    // 기기 모델은 지원하는 모바일 플랫폼에서만 전달하는 선택적 정보.
    final info = await AppDevice.info;
    final device = GdsDevice.current;
    final result = await GetAuthRefresh(
      grimityAppModel: info.model,
      grimityAppDevice: device.name,
    ).request();

    await AppSecureStorage.accessToken.set(result.accessToken);
    await AppSecureStorage.refreshToken.set(result.refreshToken);
  }
}
