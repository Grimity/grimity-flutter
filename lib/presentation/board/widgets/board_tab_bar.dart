import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/enums/post_type_filter.dart';
import 'package:grimity/presentation/board/pages/board_page.dart';

/// 게시글 유형별로 목록을 전환하는 게시판 탭 바.
class BoardTabBar extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return GdsTabBar(
      controller: controller,

      // 게시글 유형별 탭 바 구성.
      items: BoardPage.postTypes.builder((value) {
        return .new(label: value.displayName);
      }),
    );
  }
}
