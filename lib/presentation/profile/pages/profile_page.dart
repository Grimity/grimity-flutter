// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/profile/views/profile_feeds.dart';
import 'package:grimity/presentation/profile/views/profile_posts.dart';
import 'package:grimity/presentation/profile/widgets/profile_app_bar.dart';
import 'package:grimity/presentation/profile/widgets/profile_banner.dart';
import 'package:grimity/presentation/profile/widgets/profile_header.dart';
import 'package:grimity/presentation/profile/widgets/profile_tab_bar.dart';
import 'package:pervice/pervice.dart';

/// 사용자 정보와 작성한 콘텐츠를 표시하는 프로필 페이지.
class ProfilePage extends StatelessWidget {
  const new({
    super.key,
    required this.url,
  });

  /// 사용자의 프로필 주소에 쓰는 고유 식별자.
  final String url;

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(
      () => GetUsersProfileByUrl(url: url),
      key: ValueKey(url),
    );

    return GdsScaffold(
      appBar: const ProfileAppBar(),
      body: service.page(
        loaded: (data) {
          final views = <GdsTabView>[
            ProfileFeeds(data: data),
            ProfilePosts(data: data),
          ];

          // 프로필 탭 전환을 제어할 컨트롤러.
          final tabController = context.useTabController(length: views.length);

          return AppBarConnection(
            appBars: [
              // 프로필 배너 표시
              AppBar(
                behavior: const MaterialAppBarBehavior(),
                body: ProfileBanner(data: data),
              ),

              // 프로필 헤더 표시
              AppBar(
                behavior: const MaterialAppBarBehavior(),
                body: ProfileHeader(data: data),
              ),

              // 탭 바 표시
              AppBar(
                behavior: const AbsoluteAppBarBehavior(),
                body: ProfileTabBar(
                  controller: tabController,
                  views: views,
                ),
              ),
            ],
            child: TabBarView(
              controller: tabController,
              children: views.keepAliveWrappers,
            ),
          );
        },
      ),
    );
  }
}
