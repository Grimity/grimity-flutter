// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/feed_ranking/views/feed_ranking_monthly.dart';
import 'package:grimity/presentation/feed_ranking/views/feed_ranking_tags.dart';
import 'package:grimity/presentation/feed_ranking/views/feed_ranking_users.dart';
import 'package:grimity/presentation/feed_ranking/views/feed_ranking_weekly.dart';
import 'package:grimity/presentation/feed_ranking/widgets/feed_ranking_header.dart';
import 'package:grimity/presentation/feed_ranking/widgets/feed_ranking_tab_bar.dart';
import 'package:grimity/presentation/navigation/navigation_view.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 인기 작가와 태그, 주간 혹은 월간 인기 그림 등의 랭킹을 표시하는 페이지.
class FeedRankingPage extends StatelessWidget with NavigationView {
  const new({super.key});

  @override
  GdsIcon get icon => .paint;

  @override
  String get label => '랭킹';

  /// 이전 조회 기간으로 이동할 수 있는 범위의 기준이 되는 서비스 출시일.
  static final releaseDate = DateTime(2025, 2, 22);

  /// 월간 조회 기간의 이동과 선택 범위를 제한하는 서비스 출시 년/월.
  static final releaseMonth = DateTime(
    releaseDate.year,
    releaseDate.month,
  );

  /// 주간 혹은 월간 인기 그림을 불러오는 동안 표시할 임시 피드 데이터.
  static final placeholder = FeedRankingsResponse(
    feeds: List.generate(34, (_) {
      return .new(
        id: '',
        title: 'Placeholder',
        thumbnail: '',
        likeCount: 0,
        viewCount: 0,
        author: .new(id: '', name: 'Placeholder', url: ''),
        isLike: false,
      );
    }),
  );

  @override
  Widget build(BuildContext context) {
    final tabController = context.useTabController(length: 2);
    context.watch(tabController);

    return AppBarConnection(
      appBars: [
        // 헤더 표시
        .new(
          behavior: const MaterialAppBarBehavior(),
          body: const FeedRankingHeader(),
        ),
        // 탭바 표시
        .new(
          behavior: const AbsoluteAppBarBehavior(),
          body: FeedRankingTabBar(controller: tabController),
        ),
      ],
      child: SliverScrollView(
        padding: context.whenDevice(
          mobile: .only(top: 12, left: 16, right: 16, bottom: 16),
          tablet: .only(top: 12, left: 20, right: 20, bottom: 20),
        ),
        spacing: context.whenDevice(
          mobile: 32,
          tablet: 56,
        ),
        slivers: [
          // 월간 혹은 주간 표시
          if (tabController.index == 0) ...[
            FeedRankingWeekly(),
          ] else ...[
            FeedRankingMonthly(),
          ],

          // 인기 작가 표시
          FeedRankingUsers(),

          // 인기 태그 표시
          FeedRankingTags(),
        ],
      ),
    );
  }
}
