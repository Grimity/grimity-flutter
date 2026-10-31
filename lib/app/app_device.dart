// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:grimity/main.dart';

/// 기기의 모델 정보를 담는 레코드.
/// `id`는 서버 로그인 요청에 전달하는 기기 식별자입니다.
typedef DeviceInfo = ({String model, String? id});

/// Android와 iOS 기기의 모델 정보를 조회하는 앱 공통 유틸리티.
abstract class AppDevice {
  static final _plugin = DeviceInfoPlugin();

  /// Android에서는 모델명을, iOS에서는 하드웨어 식별자를 사용합니다.
  static Future<DeviceInfo> get info async {
    // 테스트 환경에서는 실제 기기 조회 없이 고정된 정보를 반환.
    if (kTestMode) {
      return (
        model: 'Test Device',
        id: 'test-device',
      );
    }

    if (Platform.isAndroid) {
      final android = await _plugin.androidInfo;
      return (
        model: android.model,
        id: android.id,
      );
    } else if (Platform.isIOS) {
      final ios = await _plugin.iosInfo;
      return (
        model: ios.utsname.machine,
        id: ios.identifierForVendor,
      );
    }

    throw Exception('${Platform.operatingSystem} 플랫폼은 기기 정보 조회를 지원하지 않습니다.');
  }
}
