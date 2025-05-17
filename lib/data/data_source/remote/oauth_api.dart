import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

abstract class OAuthAPI {
  Future<String> loginWithGoogle();
  Future<String> loginWithKakao();
}

@Injectable(as: OAuthAPI)
class OAuthAPIImpl extends OAuthAPI {
  @override
  Future<String> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      return googleAuth?.accessToken ?? '';
    } on Exception {
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
    } on Exception {
      rethrow;
    }
  }
}
