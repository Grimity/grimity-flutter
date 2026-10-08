import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// 기기의 모델 정보를 담는 레코드.
/// `id`는 서버 로그인 요청에 전달하는 기기 식별자입니다.
typedef DeviceInfo = ({String model, String? id});

/// Android와 iOS 기기의 모델 정보를 조회하는 앱 공통 유틸리티.
abstract class AppDevice {
  static final _plugin = DeviceInfoPlugin();

  /// Android에서는 모델명을, iOS에서는 하드웨어 식별자를 사용합니다.
  static Future<DeviceInfo> get info async {
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
