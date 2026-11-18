// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/feed_upload/pages/feed_upload_page.dart';
import 'package:grimity/presentation/follow/screens/follow_screen.dart';
import 'package:grimity/presentation/follow/widgets/follow_user_item.dart';
import 'package:pervice/pervice.dart';

/// 나를 팔로우하는 사용자 목록을 표시하는 탭.
class Followers extends StatelessWidget with GdsTabView {
  const new({super.key});

  @override
  String get label => '팔로워';

  /// 팔로워 목록을 불러오는 동안 표시할 임시 데이터.
  static final placeholder = [
    MyFollowersResponse(
      followers: .generate(10, (_) {
        return const .new(
          id: '',
          name: 'Placeholder',
          image: '',
          url: '',
          description: 'Placeholder',
          isFollowing: false,
        );
      }),
    ),
  ];

  /// 팔로워 목록을 조회하는 서비스를 생성합니다.
  static LoadMoreService<MyFollowersResponse> createService() {
    return .new(
      builder: (cursor) => GetMeFollowers(cursor: cursor),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(createService);

    return service.builder(
      placeholder: placeholder,
      builder: (data) {
        final followers = data.expand((e) => e.followers).toList();

        // 팔로워가 아예 없을 경우.
        if (followers.isEmpty) {
          return Align(
            alignment: .topCenter,
            child: GdsEmptyState(
              illust: .user,
              title: '빛나는 나를 알아본 사람이 아직 없어요',
              action: .new(
                type: .solid,
                label: '그림 올리기',
                onTap: () {
                  // 피드 업로드 페이지로 이동.
                  context.push(const FeedUploadPage());
                },
              ),
            ),
          );
        }

        return GdsInfiniteScroll(
          onLoadMore: service.loadMore,
          enabled: service.canLoreMore,
          child: ListView.builder(
            padding: FollowScreen.scrollPadding(context),
            itemCount: followers.length,
            itemBuilder: (context, index) {
              final follower = followers[index];

              return FollowUserItem(
                nickname: follower.name,
                image: follower.image?.toImage(),
                id: follower.id,
                url: follower.url,
                isFollowing: follower.isFollowing,
              );
            },
          ),
        );
      },
    );
  }
}
