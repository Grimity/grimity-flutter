// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/settings/app_settings.dart';
import 'package:pervice/pervice.dart';

/// 앱의 화면 테마를 선택하는 설정 페이지.
class SettingsTheme extends StatelessWidget with GdsListDetailPage {
  const new({super.key});

  @override
  GdsIcon get icon => .pallete;

  @override
  String get title => '화면 테마';

  @override
  Widget build(BuildContext context) {
    final setting = AppSettings.theme;
    context.watch(setting);

    final isSystem = setting.value == .system;
    final isLight = setting.value == .light;
    final isDark = setting.value == .dark;

    return ListView(
      children: [
        GdsListItem.text(
          size: .lg,
          status: .from(selected: isSystem),
          label: '시스템 설정 모드',
          onTap: () => setting.value = .system,
        ),

        GdsListItem.text(
          size: .lg,
          status: .from(selected: isLight),
          label: '밝은 모드',
          onTap: () => setting.value = .light,
        ),

        GdsListItem.text(
          size: .lg,
          status: .from(selected: isDark),
          label: '어두운 모드',
          onTap: () => setting.value = .dark,
        ),
      ],
    );
  }
}
