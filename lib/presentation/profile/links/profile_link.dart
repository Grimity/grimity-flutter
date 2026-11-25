// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_link.dart';
import 'package:grimity/presentation/profile/pages/profile_page.dart';

/// 프로필 페이지에 대한 링크를 처리하고 해당 페이지를 엽니다.
final class ProfileLink extends AppLink {
  const new();

  @override
  void onLink(BuildContext context, Uri uri) async {
    final segments = uri.pathSegments;

    // :id
    if (segments.length != 1) return;
    if (segments.last.isEmpty) return;

    final user = await GetUsersProfileByUrl(url: segments.last).requestOrNull();

    // 링크에 포함된 아이디가 유효할 경우에만 해당 페이지 열기.
    if (user != null && context.mounted) {
      context.push(ProfilePage(url: user.url));
    }
  }
}
