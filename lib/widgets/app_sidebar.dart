// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_urls.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/business_info/pages/business_info_page.dart';
import 'package:grimity/presentation/follow/screens/follow_screen.dart';
import 'package:grimity/presentation/profile/pages/profile_page.dart';
import 'package:grimity/presentation/settings/pages/settings_page.dart';
import 'package:grimity/presentation/storage/pages/storage_page.dart';
import 'package:pervice/pervice.dart';
import 'package:url_launcher/url_launcher.dart';

/// 프로필, 팔로우 정보, 탭 목록과 서비스 정보를 표시하는 사이드바 위젯.
class AppSidebar extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch(AppUser.profileNotifier);

    return GdsSidebar(
      size: context.whenDevice(
        mobile: .md,
        tablet: .lg,
      ),
      nickname: profile.name,
      handle: profile.url,
      profile: profile.image?.toImage(),
      followerCount: profile.followerCount.toInt(),
      followingCount: profile.followingCount.toInt(),
      onProfile: () {
        // 프로필 페이지로 이동.
        context.push(ProfilePage(url: profile.url));
      },
      onNickname: () {
        // 프로필 페이지로 이동.
        context.push(ProfilePage(url: profile.url));
      },
      onHandle: () {
        // 프로필 페이지로 이동.
        context.push(ProfilePage(url: profile.url));
      },
      onFollower: () {
        // 팔로워 화면으로 이동.
        const FollowScreen(initialTab: .followers).push(context);
      },
      onFollowing: () {
        // 팔로잉 화면으로 이동.
        const FollowScreen(initialTab: .following).push(context);
      },
      onSignOut: AppUser.signOut,
      onTermsOfService: () {
        // 서비스 이용약관 열기.
        launchUrl(Uri.parse(AppUrls.termsOfService));
      },
      onPrivacyPolicy: () {
        // 개인정보 처리방침 열기.
        launchUrl(Uri.parse(AppUrls.privacyPolicy));
      },
      onBusinessInfo: () {
        // 사업자 정보 페이지로 이동.
        context.push(const BusinessInfoPage());
      },
      tabs: [
        .new(
          icon: .inbox,
          label: '보관함',
          onTap: () {
            // 보관함 페이지로 이동.
            context.push(const StoragePage());
          },
        ),
        .new(
          icon: .settings,
          label: '설정',
          onTap: () {
            // 설정 페이지로 이동.
            context.push(const SettingsPage());
          },
        ),
      ],
    );
  }
}
