import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grimity/app/environment/flavor.dart';
import 'package:grimity/app/exception/login_canceled_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class OAuthAPI {
  Future<String> loginWithGoogle();

  Future<String> loginWithKakao();

  Future<String> loginWithApple();

  Future<void> logoutWithGoogle();

  Future<void> logoutWithKakao();

  Future<void> logoutWithApple();
}

@Injectable(as: OAuthAPI)
class OAuthAPIImpl extends OAuthAPI {
  @override
  Future<String> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(clientId: Flavor.env.googleSignInClientId);

      // Clear the previously selected account so Google shows the account
      // chooser whenever the user starts a new login attempt.
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const LoginCanceledException();
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      return googleAuth.accessToken!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> loginWithKakao() async {
    final OAuthToken? token;

    try {
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      return token.accessToken;
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        throw const LoginCanceledException();
      }
      rethrow;
    } on KakaoAuthException catch (e) {
      if (e.error == AuthErrorCause.accessDenied) {
        throw const LoginCanceledException();
      }
      rethrow;
    } on KakaoApiException catch (e) {
      if (e.code == ApiErrorCause.accessDenied) {
        throw const LoginCanceledException();
      }
      rethrow;
    } on KakaoClientException catch (e) {
      if (e.reason == ClientErrorCause.cancelled) {
        throw const LoginCanceledException();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> loginWithApple() async {
    try {
      final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );

      return credential.identityToken!;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const LoginCanceledException();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logoutWithGoogle() async {
    try {
      await GoogleSignIn(clientId: Flavor.env.googleSignInClientId).signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logoutWithKakao() async {
    try {
      await UserApi.instance.logout();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logoutWithApple() async {
    // Apple 로그인은 시스템 계정 기반으로 관리되어 SDK 차원의 로그아웃 기능이 없습니다.
    // 따라서 앱 내에서는 로컬 세션(토큰/유저 정보)만 초기화하면 됩니다.
  }
}
