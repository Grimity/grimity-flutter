// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_use_case.dart';
import 'package:grimity/presentation/profile/pages/profile_page.dart';
import 'package:pervice/pervice.dart';

/// 팔로우 목록에 표시할 사용자 항목.
class FollowUserItem extends StatelessWidget {
  const new({
    super.key,
    required this.nickname,
    required this.image,
    required this.id,
    required this.url,
    required this.isFollowing,
  });

  final String nickname;
  final ImageProvider? image;
  final String id;
  final String url;
  final bool isFollowing;

  @override
  Widget build(BuildContext context) {
    // SHARED STATE
    final followerCount = context.sharedStateOf(
      () => -1,
      key: ValueKey('user-$id:follower-count'),
    );

    final isFollowing = context.sharedStateOf(
      () => this.isFollowing,
      key: ValueKey('user-$id:is-following'),
    );

    return GdsUserItem.textButton(
      nickname: nickname,
      profile: image,
      handle: url,
      onUser: () {
        // 해당 팔로워의 프로필 페이지로 이동.
        context.push(ProfilePage(url: url));
      },
      actions: [
        // 팔로우 버튼 표시
        .follow(
          following: isFollowing.value,
          onFollow: () {
            AppUseCase.follow(
              context,
              id: id,
              isFollowing: isFollowing,
              followerCount: followerCount,
            );
          },
          onUnFollow: () {
            AppUseCase.unFollow(
              context,
              id: id,
              isFollowing: isFollowing,
              followerCount: followerCount,
            );
          },
        ),
      ],
    );
  }
}
