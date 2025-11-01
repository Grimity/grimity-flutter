import 'package:google_sign_in/google_sign_in.dart';
import 'package:grimity/app/environment/flavor.dart';
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
      final GoogleSignInAccount? googleUser = await GoogleSignIn(clientId: Flavor.env.googleSignInClientId).signIn();

      if (googleUser == null) {
        throw Exception('Google sign in failed');
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
