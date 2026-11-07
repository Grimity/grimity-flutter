// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/board/pages/board_page.dart';
import 'package:grimity/presentation/following_feed/pages/following_feed_page.dart';
import 'package:grimity/presentation/home/pages/home_page.dart';
import 'package:grimity/presentation/navigation/navigation_view.dart';
import 'package:grimity/presentation/feed_ranking/pages/feed_ranking_page.dart';
import 'package:grimity/widgets/app_sidebar.dart';
import 'package:grimity/widgets/app_top_navigation.dart';
import 'package:pervice/pervice.dart';

/// 상단 내비게이션과 사이드바를 제공하고 하단 탭으로 화면을 전환하는 메인 페이지.
class NavigationPage extends StatelessWidget {
  const new({super.key});

  /// 하단 네비게이션의 각 탭에 대응하는 화면 목록.
  static const _views = <NavigationView>[
    HomePage(),
    FeedRankingPage(),
    FollowingFeedPage(),
    BoardPage(),
    _Test(icon: .message, label: 'DM', action: false),
  ];

  /// 지정한 인덱스의 내비게이션 화면으로 이동합니다.
  static void moveTo(BuildContext context, int newIndex) {
    final index = context.sharedStateOf<int>(
      () => throw StateError('내비게이션 페이지가 아직 빌드되지 않았습니다.'),
      key: ValueKey(NavigationPage),
    );

    index.value = newIndex;
  }

  @override
  Widget build(BuildContext context) {
    final index = context.sharedStateOf(() => 0, key: ValueKey(NavigationPage));
    assert(index.value < _views.length);

    // 이전에 선택한 탭의 인덱스와 페이지 전환 방향.
    final transition = context.stateOf(
      () => (index: index.value, direction: AxisDirection.up),
    );

    final newIndex = index.value;
    final oldIndex = transition.value.index;

    // 이전에 선택한 탭과 현재 탭의 위치에 따라 전환 방향 지정.
    if (oldIndex != newIndex) {
      transition.value = (
        index: newIndex,
        direction: newIndex > oldIndex ? .left : .right,
      );
    }

    // 현재 선택된 탭에 대응하는 화면.
    final view = _views[index.value];

    return GdsScaffold(
      appBar: AppTopNavigation.main(),
      drawer: const AppSidebar(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // 페이지 본문 표시
                GdsPageTransition(
                  direction: transition.value.direction,
                  child: KeyedSubtree(
                    key: ValueKey(index.value),
                    child: view,
                  ),
                ),

                // 하단 액션 버튼 표시
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: GdsFadable.builder(
                    type: .scaleFade,
                    visible: view.hasAction,
                    builder: (context) {
                      return GdsBottomNavigationButton(
                        onTap: () => view.onAction(context),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 하단 네비게이션 표시
          GdsBottomNavigation(
            index: index.value,
            tabs: _views.indexedBuilder((newIndex, view) {
              return .new(
                icon: view.icon,
                label: view.label,
                showDot: view.showDot,
                onTap: () => index.value = newIndex,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Test extends StatelessWidget with NavigationView {
  const new({
    required this.icon,
    required this.label,
    required this.action,
  });

  final bool action;

  @override
  final GdsIcon icon;

  @override
  final String label;

  @override
  bool get hasAction => action;

  @override
  Widget build(BuildContext context) {
    final counter = context.stateOf(() => 0);

    return Center(
      child: GdsGesture(
        onTap: () => counter.value = counter.value + 1,
        child: GdsText(
          '$label ${counter.value}',
          color: .textGrayBold,
          style: .title1,
        ),
      ),
    );
  }
}
