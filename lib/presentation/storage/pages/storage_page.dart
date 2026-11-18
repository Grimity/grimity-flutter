// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/storage/views/storage_liked_feeds.dart';
import 'package:grimity/presentation/storage/views/storage_liked_posts.dart';
import 'package:grimity/presentation/storage/widgets/storage_tab_bar.dart';
import 'package:grimity/presentation/storage/widgets/storage_title.dart';
import 'package:grimity/widgets/app_top_navigation.dart';
import 'package:pervice/pervice.dart';

/// 좋아요한 그림과 글을 조회하여 이를 표시하는 보관함 페이지.
class StoragePage extends StatelessWidget {
  const new({super.key});

  /// 보관함에서 전환할 탭 목록.
  static const views = <GdsTabView>[
    StorageLikedFeeds(),
    StorageLikedPosts(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.useTabController(length: views.length);

    return GdsScaffold(
      appBar: AppTopNavigation.title(),
      body: AppBarConnection(
        appBars: [
          // 보관함 제목 표시
          AppBar(
            behavior: const MaterialAppBarBehavior(),
            body: const StorageTitle(),
          ),

          // 보관함 탭바 표시
          AppBar(
            behavior: const AbsoluteAppBarBehavior(),
            body: StorageTabBar(controller: controller),
          ),
        ],
        child: TabBarView(
          controller: controller,
          children: views.keepAliveWrappers,
        ),
      ),
    );
  }
}
