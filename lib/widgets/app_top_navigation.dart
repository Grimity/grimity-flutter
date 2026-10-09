import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';

/// 화면 상단에 위치한 내비게이션으로, 작은 화면을 디자인할 때 사용됩니다.
abstract class AppTopNavigation {
  /// 로고, 검색, 알림 아이콘과 프로필 이미지를 표시하는 상단 내비게이션 위젯.
  static Widget main({Key? key}) {
    return Builder(
      builder: (context) {
        return GdsTopNavigation.main(
          key: key,
          onSearch: () {}, // TODO
          onNotification: () {}, // TODO
          onProfile: context.openDrawer,
          profile: profile.image?.responsiveImage,
          hasNotification: false,
        );
      },
    );
  }
}
