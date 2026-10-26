import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/search/pages/search_page.dart';

/// 화면 상단에 위치한 내비게이션으로, 작은 화면을 디자인할 때 사용됩니다.
abstract class AppTopNavigation {
  /// 로고, 검색, 알림 아이콘과 프로필 이미지를 표시하는 상단 내비게이션 위젯.
  static Widget main({Key? key}) {
    return Builder(
      builder: (context) {
        return GdsTopNavigation.main(
          key: key,
          onSearch: () {
            // 검색 페이지로 이동.
            context.push(const SearchPage());
          },
          onNotification: () {}, // TODO
          onProfile: context.openDrawer,
          profile: profile.image?.toImage(),
          hasNotification: profile.hasNotification,
        );
      },
    );
  }

  /// 제목, 검색, 알림 아이콘과 프로필 이미지를 표시하는 상단 내비게이션 위젯.
  static Widget title({Key? key, String? title}) {
    return Builder(
      builder: (context) {
        return GdsTopNavigation.title(
          key: key,
          onBack: context.pop,
          onSearch: () {}, // TODO
          onNotification: () {}, // TODO
          onProfile: context.openDrawer,
          title: title,
          profile: profile.image?.toImage(),
          hasNotification: profile.hasNotification,
        );
      },
    );
  }
}
