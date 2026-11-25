// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/views/show_app_update_alert.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 앱 버전 정보를 정의하고 업데이트 필요 여부를 판단하는 클래스.
final class AppVersion({
  required final int major,
  required final int minor,
  required final int patch,
}) {
  /// major.minor.patch 형식의 문자열로 생성합니다.
  factory parse(String str) {
    final $ = str.split('.');
    return .new(
      major: .parse($[0]),
      minor: .parse($[1]),
      patch: .parse($[2]),
    );
  }

  /// 비교 대상의 major 또는 minor 버전이 높아 업데이트가 필요한지 여부.
  bool needsUpdate(AppVersion other) {
    return other.major == major ? other.minor > minor : other.major > major;
  }

  /// 앱 버전을 확인하고 업데이트가 필요한 경우 안내 팝업을 표시합니다.
  static Future<void> checkForUpdate() async {
    final response = await GetAppVersion().request();
    final package = await PackageInfo.fromPlatform();
    final server = AppVersion.parse(response.version);
    final client = AppVersion.parse(package.version);

    // 앱 업데이트가 필요한 경우.
    if (client.needsUpdate(server)) {
      final context = GdsApp.navigationKey.currentContext;

      // 업데이트 안내 표시.
      if (context != null && context.mounted) {
        await showAppUpdateAlert(context);
      }
    }
  }

  @override
  String toString() => '$major.$minor.$patch';
}
