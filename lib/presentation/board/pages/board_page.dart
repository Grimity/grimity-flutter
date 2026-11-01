// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/board/views/board_app_bars.dart';
import 'package:grimity/presentation/board/views/board_view.dart';
import 'package:grimity/presentation/navigation/navigation_view.dart';
import 'package:pervice/pervice.dart';

/// 게시글 유형별 목록과 검색 기능을 제공하는 자유게시판 페이지.
class BoardPage extends StatelessWidget with NavigationView {
  const new({super.key});

  @override
  GdsIcon get icon => .board;

  @override
  String get label => '자유게시판';

  /// 게시판 탭에 표시할 게시글 유형 목록.
  static const postTypes = <PostTypeFilter>[
    .all,
    .normal,
    .question,
    .feedback,
  ];

  @override
  Widget build(BuildContext context) {
    final tabController = context.useTabController(
      length: postTypes.length,
    );

    final searchBy = context.stateOf(
      () => PostSearchBy.combined,
      key: ValueKey('board-search-by'),
    );

    final keyword = context.stateOf(
      () => '',
      key: ValueKey('board-keyword'),
    );

    return AppBarConnection(
      appBars: createBoardAppBars(
        context,
        controller: tabController,
        searchBy: searchBy,
        keyword: keyword,
      ),
      child: TabBarView(
        controller: tabController,

        // 게시글 유형별 목록 화면 구성.
        children: postTypes.builder((postType) {
          return BoardView(
            postType: postType,
            searchBy: searchBy.value,
            keyword: keyword.value,
          );
        }).keepAliveWrappers,
      ),
    );
  }
}
