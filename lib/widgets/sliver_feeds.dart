// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_use_case.dart';
import 'package:grimity/presentation/feed_detail/pages/feed_detail_page.dart';
import 'package:pervice/pervice.dart';

/// 피드 항목을 표시하는 데 필요한 정보.
typedef SliverFeed = ({
  String id,
  String thumbnail,
  String title,
  String nickname,
  int likeCount,
  int viewCount,
  bool isLike,
});

/// 인덱스에 해당하는 피드 데이터를 반환하는 빌더.
typedef SliverFeedBuilder = SliverFeed Function(
  BuildContext context,
  int index,
);

/// 피드 카드를 동적 높이의 그리드로 표시하는 슬리버.
class SliverFeeds extends StatelessWidget {
  const new({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final SliverFeedBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverDynamicHeightGridView(
      crossAxisCount: context.feedGridCrossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: context.whenDevice(
        mobile: 24,
        tablet: 40,
      ),
      itemCount: itemCount,
      builder: (context, index) {
        final feed = itemBuilder(context, index);

        // SHARED STATE
        final isLike = context.sharedStateOf(
          () => feed.isLike,
          key: ValueKey('feed-${feed.id}:is-like'),
        );

        final likeCount = context.sharedStateOf(
          () => feed.likeCount,
          key: ValueKey('feed-${feed.id}:like-count'),
        );

        final viewCount = context.sharedStateOf(
          () => feed.viewCount,
          key: ValueKey('feed-${feed.id}:view-count'),
        );

        return GdsAlbum(
          image: feed.thumbnail.toImage(),
          title: feed.title,
          nickname: feed.nickname,
          likeCount: likeCount.value,
          viewCount: viewCount.value,
          like: isLike.value,
          onTap: () {
            // 피드 상세 페이지로 이동.
            context.push(FeedDetailPage(id: feed.id));
          },
          onLike: (value) {
            AppUseCase.likeFeed(
              context,
              id: feed.id,
              value: value,
              isLike: isLike,
              likeCount: likeCount,
            );
          },
        );
      },
    );
  }
}
