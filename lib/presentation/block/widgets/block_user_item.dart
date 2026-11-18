// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_use_case.dart';
import 'package:grimity/presentation/profile/pages/profile_page.dart';
import 'package:pervice/pervice.dart';

/// 차단 목록에 표시할 사용자 항목.
class BlockUserItem extends StatelessWidget {
  const new({
    super.key,
    required this.nickname,
    required this.image,
    required this.id,
    required this.url,
    required this.isBlocking,
  });

  final String nickname;
  final ImageProvider? image;
  final String id;
  final String url;
  final bool isBlocking;

  @override
  Widget build(BuildContext context) {
    // SHARED STATE
    final isBlocking = context.sharedStateOf(
      () => this.isBlocking,
      key: ValueKey('user-$id:is-blocking'),
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
        .new(
          type: isBlocking.value ? .outlined : .solid,
          label: isBlocking.value ? '차단 해제' : '차단',
          onTap: () {
            AppUseCase.block(
              context,
              id: id,
              value: !isBlocking.value,
              isBlocking: isBlocking,
            );
          }
        ),
      ],
    );
  }
}
