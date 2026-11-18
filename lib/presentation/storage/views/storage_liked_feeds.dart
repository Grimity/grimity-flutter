// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/navigation/navigation_page.dart';
import 'package:grimity/widgets/sliver_feeds.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 좋아요한 그림 목록을 표시하는 탭.
class StorageLikedFeeds extends StatelessWidget with GdsTabView {
  const new({super.key});

  @override
  String get label => '좋아요한 그림';

  /// 좋아요한 그림을 불러오는 동안 표시할 임시 데이터.
  static final placeholder = [
    MyLikeFeedsResponse(
      feeds: List.generate(20, (_) {
        return .new(
          id: '',
          title: 'Placeholder',
          thumbnail: '',
          likeCount: 0,
          viewCount: 0,
          cards: [],
          commentCount: 0,
          createdAt: .now(),
          author: const .new(
            id: '',
            name: 'Placeholder',
            url: '',
          ),
        );
      }),
    ),
  ];

  /// 좋아요한 그림 목록을 페이지별로 불러오는 서비스를 생성합니다.
  LoadMoreService<MyLikeFeedsResponse> createService() {
    return .new(
      builder: (cursor) => GetMeLikeFeeds(cursor: cursor),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(
      createService,
      key: ValueKey(StorageLikedFeeds),
    );

    return service.builder(
      placeholder: placeholder,
      builder: (data) {
        final feeds = data.expand((e) => e.feeds).toList();

        // 좋아요한 그림이 아예 없을 경우.
        if (feeds.isEmpty) {
          return Align(
            alignment: .topCenter,
            child: GdsEmptyState(
              illust: .resultNull,
              title: '좋아요한 그림이 없어요',
              action: .new(
                type: .solid,
                label: '인기 그림 둘러보기',
                onTap: () {
                  // 초기 페이지로 이동.
                  context.popUntilFirst();

                  // 랭킹 페이지로 이동.
                  NavigationPage.moveTo(context, 1);
                },
              ),
            ),
          );
        }

        return GdsInfiniteScroll(
          onLoadMore: service.loadMore,
          enabled: service.canLoreMore,
          child: SliverScrollView(
            padding: context.whenDevice(
              mobile: 16.all,
              tablet: 20.all,
            ),
            slivers: [
              SliverFeeds(
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
                    isLike: true,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
