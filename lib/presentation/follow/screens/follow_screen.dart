// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/follow/views/followers.dart';
import 'package:grimity/presentation/follow/views/following.dart';
import 'package:grimity/widgets/app_top_navigation.dart';
import 'package:pervice/pervice.dart';

/// 팔로우 페이지에서 표시할 탭의 유형.
enum FollowScreenTab {
  following(Following()),
  followers(Followers());

  const new(this.view);

  final GdsTabView view;
}

/// 팔로워와 팔로잉 목록을 탭으로 표시하는 화면.
class FollowScreen extends GdsBasicScreen {
  const new({
    required this.initialTab,
  });

  final FollowScreenTab initialTab;

  @override
  String get title => profile.name;

  @override
  bool get scroll => false;

  /// 기기 유형에 대응하는 스크롤 여백을 반환합니다.
  static EdgeInsets scrollPadding(BuildContext context) {
    return context.whenDevice(
      mobile: 12.top + 16.bottom + 16.horizontal,
      tablet: 12.top + 20.bottom + 20.horizontal,
    );
  }

  @override
  GdsBasicContent build(BuildContext context) {
    final tabs = FollowScreenTab.values;
    final items = tabs.builder((tab) => tab.view.item);
    final pages = tabs.builder((tab) => tab.view);

    // 팔로워, 팔로잉 탭 전환을 관리할 컨트롤러.
    final controller = context.useTabController(length: tabs.length);

    return .new(
      appBar: AppTopNavigation.title(),
      child: Column(
        mainAxisSize: .min,
        children: [
          // 탭바 표시
          Padding(
            padding: context.whenDevice(
              mobile: 16.horizontal,
              tablet: 20.horizontal + 8.top,
            ),
            child: GdsTabBar(
              items: items,
              controller: controller,
            ),
          ),

          // 탭뷰 표시
          Flexible(
            child: TabBarView(
              controller: controller,
              children: pages.keepAliveWrappers,
            ),
          ),
        ],
      ),
    );
  }
}
