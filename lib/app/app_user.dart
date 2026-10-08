import 'package:flutter/foundation.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_oauth.dart';
import 'package:grimity/app/app_secure_storage.dart';
import 'package:grimity/util/app_device.dart';

/// 현재 사용자의 로그인 여부와 로딩 진행 상황을 나타내는 상태.
enum AppUserStatus {
  none,
  loading,
  loaded,
  logout,
}

/// 소셜 로그인과 앱 토큰 저장, 현재 사용자 정보 조회를 처리합니다.
abstract class AppUser {
  static final _statusNotifier = ValueNotifier(AppUserStatus.none);

  static MyProfileResponse? _profile;

  /// 사용자의 프로필 정보를 반환합니다.
  static MyProfileResponse get profile {
    assert(_profile != null);
    return _profile ?? (throw StateError('불러오기 전에는 참조되지 않아야 합니다.'));
  }

  /// 현재 사용자 정보 로딩 및 로그인 상태.
  static AppUserStatus get status => _statusNotifier.value;

  /// 사용자 상태를 변경하고 이를 알립니다.
  static set status(AppUserStatus newStatus) {
    _statusNotifier.value = newStatus;
  }

  /// 보안 저장소에 액세스 토큰이 저장되어 있는지 여부를 반환합니다.
  static Future<bool> get hasToken async {
    return await AppSecureStorage.accessToken.get() != null;
  }

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

  ///
  static Future<void> signOut() async {
    await AppSecureStorage.accessToken.delete();
    await AppSecureStorage.refreshToken.delete();

    _profile = null;
    status = .logout;
  }

  /// 저장된 토큰 유무에 따라 사용자 정보를 불러옵니다.
  static Future<void> setup() async {
    status = .loading;

    if (await hasToken) {
      _profile = await GetMe().request();
      status = .loaded;
    } else {
      status = .logout;
    }
  }
}
