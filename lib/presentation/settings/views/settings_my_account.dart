// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/settings/views/settings_nickname.dart';
import 'package:grimity/presentation/settings/views/settings_profile_url.dart';

/// 계정 정보 설정과 로그아웃, 회원 탈퇴 항목을 표시하는 설정 페이지.
class SettingsMyAccount extends StatelessWidget with GdsListDetailPage {
  const new({super.key});

  @override
  GdsIcon get icon => .person;

  @override
  String get title => '내 계정';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              GdsListItem.rightIcon(
                icon: .chevronRightThick,
                iconLabel: profile.name,
                label: '닉네임',
                onTap: () {
                  // 닉네임 설정 페이지로 이동.
                  context.push(const SettingsNickname());
                },
              ),

              GdsListItem.rightIcon(
                icon: .chevronRightThick,
                iconLabel: '',
                label: '프로필 URL',
                onTap: () {
                  // 프로필 URL 설정 페이지로 이동.
                  context.push(const SettingsProfileUrl());
                },
              ),

              GdsListItem.text(
                size: .lg,
                label: '로그아웃',
                onTap: AppUser.signOut,
              ),
            ],
          ),
        ),

        // 하단에 회원 탈퇴 버튼 표시
        Padding(
          padding: 40.bottom,
          child: GdsButton.text(
            size: .sm,
            type: .borderless,
            variant: .assistive,
            label: '탈퇴하기',
            onTap: AppUser.delete,
          ),
        ),
      ],
    );
  }
}
