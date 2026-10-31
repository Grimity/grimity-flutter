// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:grimity/api/api.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// 소셜 로그인 SDK를 통해 서버 인증에 사용할 토큰을 발급받습니다.
abstract class AppOAuth {
  static const _kakaoNativeAppKey = '9ef16b15112d4c1ad60660adc4c39a93';
  static const _googleIosClientId = '50047733044-l3hdgkhpmg603v03b7fa7gni87kvpb6u.apps.googleusercontent.com';
  static const _googleServerClientId = '50047733044-ncm722ougs371cg1mln6rirv9h8prc6h.apps.googleusercontent.com';

  /// 앱 실행 시 구글 및 카카오 SDK를 초기화합니다.
  static Future<void> setup() async {
    await KakaoSdk.init(nativeAppKey: _kakaoNativeAppKey);

    await GoogleSignIn.instance.initialize(
      clientId: Platform.isIOS ? _googleIosClientId : null,
      serverClientId: _googleServerClientId,
    );
  }

  /// 카카오와 구글은 액세스 토큰, 애플은 ID 토큰을 반환합니다.
  /// 사용자가 로그인을 취소하면 null을 반환합니다.
  static Future<String?> signIn(AuthProvider provider) => switch (provider) {
    .kakao => _signInWithKakao(),
    .apple => _signInWithApple(),
    .google => _signInWithGoogle(),
  };

  /// 구글 로그인 후 액세스 토큰을 반환하며, 계정 선택을 취소하면 null을 반환합니다.
  static Future<String?> _signInWithGoogle() async {
    try {
      // 로그인할 때마다 계정을 선택할 수 있도록 이전 SDK 세션을 해제합니다.
      final google = GoogleSignIn.instance;
      const scopes = ['email', 'profile'];
      await google.signOut();

      final account = await google.authenticate(scopeHint: scopes);

      // 이미 동의한 권한으로 토큰을 조회하고, 필요한 경우 추가 동의를 요청합니다.
      final authorization =
          await account.authorizationClient.authorizationForScopes(scopes) ??
          await account.authorizationClient.authorizeScopes(scopes);

      final token = authorization.accessToken;
      if (token.isEmpty) {
        throw StateError('구글 로그인 토큰을 발급받지 못했습니다.');
      }

      return token;
    } on GoogleSignInException catch (error) {
      // 사용자가 로그인 또는 권한 동의를 취소한 경우.
      if (error.code == .canceled) {
        return null;
      }

      rethrow;
    }
  }

  /// 카카오톡 또는 카카오 계정으로 로그인하며, 취소하면 null을 반환합니다.
  static Future<String?> _signInWithKakao() async {
    try {
      final token = await isKakaoTalkInstalled()
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      return token.accessToken;
    } on KakaoClientException catch (error) {
      // 사용자가 카카오 로그인을 취소한 경우.
      if (error.reason == .cancelled) {
        return null;
      }

      rethrow;
    } on KakaoAuthException catch (error) {
      // 사용자가 동의 화면에서 로그인을 취소한 경우.
      if (error.error == .accessDenied) {
        return null;
      }

      rethrow;
    }
  }

  /// 애플 로그인 후 ID 토큰을 반환하며, 인증을 취소하면 null을 반환합니다.
  static Future<String?> _signInWithApple() async {
    assert(Platform.isIOS, '애플 로그인은 iOS에서만 지원합니다.');

    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [.email]);
      final token = credential.identityToken;
      if (token == null || token.isEmpty) {
        throw StateError('애플 로그인 토큰을 발급받지 못했습니다.');
      }

      return token;
    } on SignInWithAppleAuthorizationException catch (error) {
      // 사용자가 애플 로그인을 취소한 경우.
      if (error.code == .canceled) {
        return null;
      }

      rethrow;
    }
  }
}
