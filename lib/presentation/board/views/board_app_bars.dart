// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:material_ui/material_ui.dart' hide AppBar;
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/board/widgets/board_header.dart';
import 'package:grimity/presentation/board/widgets/board_search.dart';
import 'package:grimity/presentation/board/widgets/board_tab_bar.dart';
import 'package:pervice/pervice.dart';

/// 게시판 헤더, 검색창, 탭 바를 배치한 앱바 목록을 생성합니다.
List<AppBar> createBoardAppBars(
  BuildContext context, {
  required TabController controller,
  required ValueState<PostSearchBy> searchBy,
  required ValueState<String> keyword,
}) {
  if (context.isMobile) {
    return [
      // 헤더, 검색창 표시
      AppBar(
        behavior: const MaterialAppBarBehavior(floating: true),
        body: Padding(
          padding: 16.top + 20.bottom + 16.horizontal,
          child: Column(
            mainAxisSize: .min,
            spacing: 12,
            children: [
              const BoardHeader(),
              BoardSearch(
                searchBy: searchBy,
                keyword: keyword,
              ),
            ],
          ),
        ),
      ),

      // 탭 바 표시
      AppBar(
        behavior: const AbsoluteAppBarBehavior(),
        body: Padding(
          padding: 16.horizontal,
          child: BoardTabBar(controller: controller),
        ),
      ),
    ];
  }

  // Tablet
  return [
    // 헤더 표시
    AppBar(
      behavior: const MaterialAppBarBehavior(floating: true),
      body: Padding(
        padding: 24.vertical + 20.horizontal,
        child: const Column(
          mainAxisSize: .min,
          spacing: 12,
          children: [
            BoardHeader(),
          ],
        ),
      ),
    ),

    // 탭 바, 검색창 표시
    AppBar(
      behavior: const AbsoluteAppBarBehavior(),
      body: Padding(
        padding: 20.horizontal,
        child: BoardTabBar(
          controller: controller,
          trailing: SizedBox(
            width: 320,
            child: BoardSearch(
              searchBy: searchBy,
              keyword: keyword,
            ),
          ),
        ),
      ),
    ),
  ];
}
