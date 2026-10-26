import 'package:flutter/material.dart' hide AppBar;
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
          padding: const .only(top: 16, bottom: 20, left: 16, right: 16),
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
          padding: const .symmetric(horizontal: 16),
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
      body: const Padding(
        padding: .symmetric(vertical: 24, horizontal: 20),
        child: Column(
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
        padding: .symmetric(horizontal: 20),
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
