import 'package:injectable/injectable.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

abstract class OAuthAPI {
  Future<String> loginWithKakao();
}

@Injectable(as: OAuthAPI)
class OAuthAPIImpl extends OAuthAPI {
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
