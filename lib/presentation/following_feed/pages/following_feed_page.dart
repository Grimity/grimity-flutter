// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/following_feed/views/following_feeds.dart';
import 'package:grimity/presentation/following_feed/views/following_users.dart';
import 'package:grimity/presentation/navigation/navigation_view.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 팔로우한 작가의 피드와 추천 인기 작가를 표시하는 페이지.
class FollowingFeedPage extends StatelessWidget with NavigationView {
  const new({super.key});

  @override
  GdsIcon get icon => .following;

  @override
  String get label => '팔로잉';

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(FollowingFeeds.createService);

    return GdsInfiniteScroll(
      onLoadMore: service.loadMore,
      enabled: service.canLoreMore,
      child: SliverScrollView(
        maxWidth: 600,
        padding: context.whenDevice(
          mobile: .only(top: 8, left: 16, right: 16, bottom: 16),
          tablet: .symmetric(vertical: 24, horizontal: 20),
        ),
        slivers: [
          // 팔로잉 피드 목록 표시
          FollowingFeeds(service: service),

          // 더이상 보여줄 피드가 없을 경우에 인기 작가 목록 표시
          if (!service.canLoreMore) ...[
            FollowingUsers(),
          ],
        ],
      ),
    );
  }
}
