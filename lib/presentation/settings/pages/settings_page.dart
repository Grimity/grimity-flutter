// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/settings/views/settings_contact.dart';
import 'package:grimity/presentation/settings/views/settings_my_account.dart';
import 'package:grimity/presentation/settings/views/settings_guide.dart';

/// 앱 설정 항목을 목록과 상세 화면으로 표시하는 적응형 페이지.
class SettingsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsListDetail(
      title: '설정',
      pages: const [
        // 내 계정
        SettingsMyAccount(),

        // 이용 안내
        SettingsGuide(),

        // 문의하기
        SettingsContact(),
      ],
    );
  }
}
