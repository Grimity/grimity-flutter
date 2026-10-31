// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/enum/post_type_filter.dart';
import 'package:grimity/presentation/board/pages/board_page.dart';

/// 게시글 유형별로 목록을 전환하는 게시판 탭 바.
class BoardTabBar extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
    this.trailing,
  });

  final TabController controller;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GdsTabBar(
      controller: controller,
      trailing: trailing,

      // 게시글 유형별 탭 바 구성.
      items: BoardPage.postTypes.builder((value) {
        return .new(label: value.displayName);
      }),
    );
  }
}
