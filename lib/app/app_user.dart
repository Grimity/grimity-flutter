import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_oauth.dart';
import 'package:grimity/app/app_secure_storage.dart';
import 'package:grimity/util/app_device.dart';

/// 소셜 로그인과 앱 토큰 저장, 현재 사용자 정보 조회를 처리합니다.
abstract class AppUser {
  static MyProfileResponse? _profile;

  /// 로그인을 완료한 사용자의 프로필. 로그인 전에는 null입니다.
  static MyProfileResponse? get profile => _profile;

  /// 소셜 인증 토큰으로 서버에 로그인한 뒤 사용자 프로필을 반환합니다.
  static Future<MyProfileResponse> signIn(AuthProvider provider) async {
    final token = await AppOAuth.signIn(provider);
    final device = await AppDevice.info;
    final result = await PostAuthLogin(
      grimityAppModel: device.model,
      request: .new(
        provider: provider,
        deviceId: device.id,
        providerAccessToken: token,
      ),
    ).request();

    await AppSecureStorage.accessToken.set(result.accessToken);
    await AppSecureStorage.refreshToken.set(result.refreshToken);

    return _profile = await GetMe().request();
  }
}
