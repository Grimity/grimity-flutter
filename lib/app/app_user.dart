// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_secure_storage.dart';
import 'package:grimity/app/app_device.dart';

/// 사용자의 프로필 정보를 반환합니다.
MyProfileResponse get profile => AppUser.profile;

/// 현재 사용자의 로그인 여부와 로딩 진행 상황을 나타내는 상태.
enum AppUserStatus {
  loading,
  loaded,
  unauth,
}

/// 소셜 로그인과 앱 토큰 저장, 현재 사용자 정보 조회를 처리합니다.
abstract class AppUser {
  /// 현재 사용자 상태를 관리하고 변경을 알리기 위해 사용됩니다.
  static final statusNotifier = ValueNotifier(AppUserStatus.loading);

  /// 마지막으로 불러온 현재 사용자의 프로필.
  static MyProfileResponse? _profile;

  /// 사용자의 프로필 정보를 반환합니다.
  static MyProfileResponse get profile {
    assert(_profile != null);
    return _profile ?? (throw StateError('불러오기 전에는 참조되지 않아야 합니다.'));
  }

  /// 마지막으로 불러온 현재 사용자의 앨범 목록.
  static List<AlbumBaseResponse>? _albums;

  /// 사용자의 앨범 목록을 반환합니다.
  static List<AlbumBaseResponse> get albums {
    assert(_albums != null);
    return _albums ?? (throw StateError('불러오기 전에는 참조되지 않아야 합니다.'));
  }

  /// 현재 사용자 정보 로딩 및 로그인 상태.
  static AppUserStatus get status => statusNotifier.value;

  /// 사용자 상태를 변경하고 이를 알립니다.
  static set status(AppUserStatus newStatus) {
    statusNotifier.value = newStatus;
  }

  /// 보안 저장소에 액세스 토큰이 저장되어 있는지 여부를 반환합니다.
  static Future<bool> get hasToken async {
    return await AppSecureStorage.accessToken.get() != null;
  }

  /// 소셜 인증 토큰으로 서버에 로그인한 뒤 사용자 프로필을 불러옵니다.
  static Future<void> signIn(
    AuthProvider provider,
    String accessToken,
  ) async {
    final info = await AppDevice.info;
    final device = GdsDevice.current;
    final service = PostAuthLogin(
      grimityAppDevice: device.name,
      grimityAppModel: info.model,
      request: .new(
        provider: provider,
        deviceId: info.id,
        providerAccessToken: accessToken,
      ),
    );

    final response = await service.request();

    await AppSecureStorage.accessToken.set(response.accessToken);
    await AppSecureStorage.refreshToken.set(response.refreshToken);
    initialize();
  }

  /// 소셜 인증 토큰으로 서버에 회원가입한 뒤 사용자 프로필을 불러옵니다.
  static Future<void> signUp(
    AuthProvider provider,
    String accessToken,
    String nickname,
    String url,
  ) async {
    final info = await AppDevice.info;
    final device = GdsDevice.current;
    final service = PostAuthRegister(
      grimityAppDevice: device.name,
      grimityAppModel: info.model,
      request: .new(
        provider: provider,
        providerAccessToken: accessToken,
        name: nickname,
        url: url,
      ),
    );

    final response = await service.request();

    await AppSecureStorage.accessToken.set(response.accessToken);
    await AppSecureStorage.refreshToken.set(response.refreshToken);
    initialize();
  }

  /// 기기 종류와 모델명을 전달해 서버에 로그아웃을 요청합니다.
  /// 이후 저장된 토큰과 프로필을 삭제합니다.
  static Future<void> signOut() async {
    final info = await AppDevice.info;
    final device = GdsDevice.current;
    final service = PostAuthLogout(
      grimityAppDevice: device.name,
      grimityAppModel: info.model,
    );

    await service.request();
    await AppSecureStorage.accessToken.delete();
    await AppSecureStorage.refreshToken.delete();

    _profile = null;
    _albums = null;
    status = .unauth;
  }

  /// 저장된 토큰 유무에 따라 사용자 정보를 불러옵니다.
  static Future<void> initialize() async {
    if (await hasToken) {
      try {
        final (profile, albums) = await (
          GetMe().request(),
          GetMeAlbums().request(),
        ).wait;

        _profile = profile;
        _albums = albums;
        status = .loaded;
      } catch (_) {
        status = .unauth;
        rethrow;
      }
    } else {
      status = .unauth;
    }
  }
}
