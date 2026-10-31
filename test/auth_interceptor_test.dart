// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_secure_storage.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/network/auth_interceptor.dart';

class _MockInterceptor extends Interceptor {
  late String accessToken = _generateRandomToken();
  late String refreshToken = _generateRandomToken();
  int refreshCount = 0;

  /// 그리미티의 내 프로필 응답에 해당하는 가상 사용자 정보.
  static Object userData = {
    'id': 'test-user',
    'name': '테스트 사용자',
    'image': 'https://example.com/profile.webp',
    'url': 'test_user',
    'provider': 'GOOGLE',
    'email': 'tester@example.com',
    'backgroundImage': null,
    'description': '저는 테스트용 가상 사용자입니다.',
    'links': [],
    'createdAt': '2025-02-22T00:00:00.000Z',
    'hasNotification': false,
    'hasUnreadChatMessage': false,
    'followerCount': 0,
    'followingCount': 0,
    'isVerified': false,
  };

  /// 가상의 랜덤 토큰을 발급합니다.
  static String _generateRandomToken({int length = 127}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  // 사용자에게 유효한 토큰을 부여하여 로그인된 상태를 보장합니다.
  Future<void> ensureSignIn() async {
    await AppSecureStorage.accessToken.set(accessToken);
    await AppSecureStorage.refreshToken.set(refreshToken);
  }

  /// 현재 유효한 액세스 토큰을 만료시킵니다.
  void ensureExpireAccessToken() {
    accessToken = _generateRandomToken();
  }

  /// 현재 유효한 리프레시 토큰을 만료시킵니다.
  void ensureExpireRefreshToken() {
    refreshToken = _generateRandomToken();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final authorization = options.headers['Authorization'];
    final isPublicPath = AuthInterceptor.publicPaths.contains(options.uri.path);

    // 리프레시 토큰을 Bearer 헤더에 담아 토큰 재발급 요청.
    if (options.uri.path == '/auth/refresh' && options.method == 'GET') {
      refreshCount++;

      if (authorization != 'Bearer $refreshToken') {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              data: {
                'statusCode': 401,
                'message': '리프레시 토큰이 유효하지 않습니다.',
              },
              statusCode: 401,
              requestOptions: options,
            ),
          ),
          true,
        );
      }

      // 응답 본문으로 새 토큰을 반환하며 리프레시 토큰을 교체.
      ensureExpireRefreshToken();
      return handler.resolve(
        Response(
          data: {
            'accessToken': accessToken,
            'refreshToken': refreshToken,
          },
          statusCode: 200,
          requestOptions: options,
        ),
        true,
      );
    }

    if (!isPublicPath && options.method == 'GET') {
      // 주어진 액세스 토큰이 유효하지 않은 경우.
      if (authorization != 'Bearer $accessToken') {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              data: {
                'statusCode': 401,
                'message': '액세스 토큰이 유효하지 않습니다.',
              },
              statusCode: 401,
              requestOptions: options,
            ),
          ),
          true,
        );
      }

      return handler.resolve(
        Response(
          data: options.uri.path == '/me' ? userData : [],
          statusCode: 200,
          requestOptions: options,
        ),
      );
    }

    super.onRequest(options, handler);
  }
}

void main() {
  final _MockInterceptor interceptor = _MockInterceptor();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    FlutterSecureStorage.setMockInitialValues({});

    final dio = Dio(.new(baseUrl: 'http://example.com'));
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(interceptor);

    Api.setup(dio);
  });

  test("액세스 토큰이 자동으로 재발급되는지 확인", () async {
    await interceptor.ensureSignIn();

    await AppUser.initialize();
    expect(
      AppUser.status,
      AppUserStatus.loaded,
      reason: '사용자 정보를 불러오는데 실패했습니다.',
    );

    // 유효한 액세스 토큰 만료시키기.
    interceptor.ensureExpireAccessToken();

    await AppUser.initialize();
    expect(
      AppUser.status,
      AppUserStatus.loaded,
      reason: '액세스 토큰 만료 시, 재발급에 실패했습니다.',
    );
  });

  test('동시에 만료된 요청이 토큰을 한 번만 갱신하고 함께 성공하는지 확인', () async {
    await interceptor.ensureSignIn();
    final oldRefreshCount = interceptor.refreshCount;

    // 유효한 액세스 토큰 만료시키기.
    interceptor.ensureExpireAccessToken();

    // 요청을 동시에 3번하기.
    final profiles = await Future.wait(
      List.generate(3, (_) => GetMe().request()),
    );

    // 모든 요청에서 정상적으로 사용자 정보를 반환했는지 확인.
    expect(profiles.every((e) => e.id == 'test-user'), isTrue);

    // 토큰 갱신을 한 번만 수행했는지 확인.
    expect(interceptor.refreshCount, oldRefreshCount + 1);

    final accessToken = await AppSecureStorage.accessToken.get();
    final refreshToken = await AppSecureStorage.refreshToken.get();

    // 새로 발급된 액세스 토큰과 리프레시 토큰이 저장됐는지 확인.
    expect(accessToken, interceptor.accessToken);
    expect(refreshToken, interceptor.refreshToken);
  });

  test('리프레시 토큰이 만료되면 오류를 전달하고 저장된 토큰을 모두 삭제하는지 확인', () async {
    await interceptor.ensureSignIn();
    final oldRefreshCount = interceptor.refreshCount;

    // 유효한 액세스과 리프레시 토큰 모두 만료시키기.
    interceptor.ensureExpireAccessToken();
    interceptor.ensureExpireRefreshToken();

    final unauthorized = isA<DioException>().having(
      (error) => error.response?.statusCode,
      'statusCode',
      401,
    );

    // 토큰 갱신 실패 후 401 인증 오류가 전달되는지 확인.
    await expectLater(GetMe().request(), throwsA(unauthorized));

    // 토큰 갱신을 한 번만 시도했는지 확인.
    expect(interceptor.refreshCount, oldRefreshCount + 1);

    final accessToken = await AppSecureStorage.accessToken.get();
    final refreshToken = await AppSecureStorage.refreshToken.get();

    // 인증에 실패하면 저장된 토큰이 모두 삭제되는지 확인.
    expect(accessToken, isNull);
    expect(refreshToken, isNull);
  });
}
