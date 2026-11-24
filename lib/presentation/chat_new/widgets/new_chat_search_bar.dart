// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';
import 'package:pervice/pervice.dart';

/// 새 메시지를 보낼 작가를 검색하는 입력 필드.
class NewChatSearchBar extends StatelessWidget {
  const new({
    super.key,
    required this.keyword,
  });

  final ValueState<String> keyword;

  @override
  Widget build(BuildContext context) {
    context.watch(AppUser.profileNotifier);

    return Padding(
      padding: context.whenDevice(
        mobile: 8.vertical + 16.horizontal,
        tablet: 8.vertical + 20.horizontal,
      ),
      child: GdsTextField.search(
        size: .md,
        placeholder: '누구에게 메시지를 보낼까요?',
        onSubmitted: keyword.setter,

        // 팔로잉한 작가가 한 명이라도 있을 때만 활성화.
        status: .from(enabled: profile.followingCount > 0),
      ),
    );
  }
}
