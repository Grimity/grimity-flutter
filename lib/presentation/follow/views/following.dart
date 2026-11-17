// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/follow/screens/follow_screen.dart';
import 'package:grimity/presentation/follow/widgets/follow_user_item.dart';
import 'package:grimity/presentation/navigation/navigation_page.dart';
import 'package:pervice/pervice.dart';

/// 내가 팔로우하는 사용자 목록을 표시하는 탭.
class Following extends StatelessWidget with GdsTabView {
  const new({super.key});

  @override
  String get label => '팔로잉';

  /// 팔로잉 목록을 불러오는 동안 표시할 임시 데이터.
  static final placeholder = [
    MyFollowingsResponse(
      followings: .generate(10, (_) {
        return const .new(
          id: '',
          name: 'Placeholder',
          image: '',
          url: '',
          description: 'Placeholder',
        );
      }),
    ),
  ];

  /// 팔로잉 목록을 조회하는 서비스를 생성합니다.
  static LoadMoreService<MyFollowingsResponse> createService() {
    return .new(
      builder: (cursor) => GetMeFollowings(cursor: cursor),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(createService);

    return service.builder(
      placeholder: placeholder,
      builder: (data) {
        final followings = data.expand((e) => e.followings).toList();

        // 팔로잉이 아예 없을 경우.
        if (followings.isEmpty) {
          return Align(
            alignment: .topCenter,
            child: GdsEmptyState(
              illust: .user,
              title: '팔로우한 작가가 없어요',
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
          child: ListView.builder(
            padding: FollowScreen.scrollPaddingOf(context),
            itemCount: followings.length,
            itemBuilder: (context, index) {
              final following = followings[index];

              return FollowUserItem(
                nickname: following.name,
                image: following.image?.toImage(),
                id: following.id,
                url: following.url,
                isFollowing: true,
              );
            },
          ),
        );
      },
    );
  }
}
