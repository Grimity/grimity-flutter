// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_urls.dart';
import 'package:url_launcher/url_launcher.dart';

/// 카카오톡과 이메일 문의 항목을 표시하는 설정 화면.
class SettingsContact extends StatelessWidget with GdsListDetailPage {
  const new({super.key});

  @override
  GdsIcon get icon => .questionCircle;

  @override
  String get title => '문의하기';

  /// 그리미티 문의 이메일 주소.
  static const email = 'support@grimity.com';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GdsListItem.text(
          size: .lg,
          label: '오픈 카카오톡으로 이동',
          onTap: () {
            // 그리미티 카카오톡 오픈채팅방 열기.
            launchUrl(Uri.parse(AppUrls.kakaoTalkOpenChat));
          },
        ),

        GdsListItem.text(
          size: .lg,
          label: '메일로 보내기',
          onTap: () {
            // 문의 메일 작성 화면 열기.
            launchUrl(Uri(scheme: 'mailto', path: email));
          },
        ),
      ],
    );
  }
}
