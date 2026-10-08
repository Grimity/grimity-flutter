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

  static final _google = GoogleSignIn(
    clientId: Platform.isIOS ? _googleIosClientId : null,
    serverClientId: _googleServerClientId,
  );

  /// 앱 실행 시 카카오 SDK를 초기화합니다.
  static void setup() {
    KakaoSdk.init(nativeAppKey: _kakaoNativeAppKey);
  }

  /// 카카오와 구글은 액세스 토큰, 애플은 ID 토큰을 반환합니다.
  static Future<String> signIn(AuthProvider provider) => switch (provider) {
    .kakao => _signInWithKakao(),
    .apple => _signInWithApple(),
    .google => _signInWithGoogle(),
  };

  static Future<String> _signInWithGoogle() async {
    // 로그인할 때마다 계정을 선택할 수 있도록 이전 SDK 세션을 해제합니다.
    await _google.signOut();
    final account = await _google.signIn();

    // 사용자가 계정을 선택하지 않은 경우.
    if (account == null) {
      throw StateError('');
    }

    final authentication = await account.authentication;
    final token = authentication.accessToken;
    if (token == null || token.isEmpty) {
      throw StateError('구글 로그인 토큰을 발급받지 못했습니다.');
    }

    return token;
  }

  static Future<String> _signInWithKakao() async {
    final token = await isKakaoTalkInstalled()
        ? await UserApi.instance.loginWithKakaoTalk()
        : await UserApi.instance.loginWithKakaoAccount();

    return token.accessToken;
  }

  static Future<String> _signInWithApple() async {
    assert(Platform.isIOS, '애플 로그인은 iOS에서만 지원합니다.');

    final credential = await SignInWithApple.getAppleIDCredential(scopes: [.email]);
    final token = credential.identityToken;
    if (token == null || token.isEmpty) {
      throw StateError('애플 로그인 토큰을 발급받지 못했습니다.');
    }

    return token;
  }
}
