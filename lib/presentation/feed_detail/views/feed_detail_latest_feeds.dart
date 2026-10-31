// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/widgets/sliver_column.dart';
import 'package:grimity/widgets/sliver_feeds.dart';

/// 피드 상세에서 최신 그림을 앨범 카드 그리드로 표시하는 위젯.
class FeedDetailLatestFeeds extends StatelessWidget {
  const new({
    super.key,
    required this.service,
  });

  final LoadMoreService<LatestFeedsResponse> service;

  /// 최신 그림을 불러오는 동안 표시할 임시 피드 데이터.
  static final placeholder = [
    LatestFeedsResponse(
      feeds: List.generate(10, (_) {
        return .new(
          id: '',
          title: 'Placeholder',
          thumbnail: '',
          likeCount: 0,
          viewCount: 0,
          author: .new(id: '', name: 'Placeholder', url: ''),
          createdAt: .now(),
          isLike: false,
        );
      }),
    ),
  ];

  /// 최신 그림 목록을 조회하는 서비스를 생성합니다.
  static LoadMoreService<LatestFeedsResponse> createService() {
    return .new(
      builder: (cursor) => GetFeedsLatest(cursor: cursor),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverColumn(
      spacing: context.whenDevice(
        mobile: 16,
        tablet: 24,
      ),
      children: [
        // 제목 표시
        SliverToBoxAdapter(
          child: GdsText(
            '최신 그림',
            color: .textGrayBold,
            style: .title3,
          ),
        ),

        // 본문 표시
        service.sliver(
          placeholder: placeholder,
          builder: (data) {
            final feeds = data.expand((e) => e.feeds).toList();

            return SliverFeeds(
              itemCount: feeds.length,
              itemBuilder: (context, index) {
                final feed = feeds[index];

                return (
                  id: feed.id,
                  thumbnail: feed.thumbnail,
                  title: feed.title,
                  nickname: feed.author.name,
                  likeCount: feed.likeCount.toInt(),
                  viewCount: feed.viewCount.toInt(),
                  isLike: feed.isLike,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
