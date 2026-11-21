// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:grimity/app/settings/enum_setting.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 앱에서 사용하는 설정을 관리합니다.
abstract class AppSettings {
  /// 앱 설정 값을 저장하고 불러오는 로컬 저장소.
  static late final SharedPreferences prefs;

  /// 앱에서 사용할 화면 테마 설정.
  static final theme = EnumSetting<ThemeMode>(
    key: 'theme',
    initialValue: .system,
    values: ThemeMode.values,
  );

  /// 저장된 앱 설정을 불러옵니다.
  static Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }
}
