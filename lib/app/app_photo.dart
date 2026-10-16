import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';

/// 사진 접근 권한이 거부된 경우 발생하는 예외.
class PhotoPermissionException implements Exception {
  const new();
}

/// 앱의 사진 접근 권한을 조회·요청하고 상태 변경을 알립니다.
abstract class AppPhoto {
  /// 위치 정보를 제외한 이미지 접근 권한 설정.
  static final requestOption = PermissionRequestOption(
    androidPermission: .new(
      type: .image,
      mediaLocation: false,
    ),
  );

  /// 사진 접근 권한 상태를 보관하고 변경을 알리는 노티파이어.
  static final permissionNotifier = ValueNotifier<PermissionState?>(null);

  /// 초기화된 사진 접근 권한 상태를 반환합니다.
  static PermissionState get permission => permissionNotifier.value!;

  /// 사진 접근 권한을 요청하고 접근 가능 여부를 반환합니다.
  static Future<bool> requestPermission() async {
    final permission = await PhotoManager.requestPermissionExtend(
      requestOption: requestOption,
    );

    return permission.hasAccess;
  }

  /// 권한 요청 없이 현재 사진 접근 권한 상태를 조회하고 저장합니다.
  static Future<void> initialize() async {
    permissionNotifier.value = await PhotoManager.getPermissionState(
      requestOption: requestOption,
    );
  }
}
