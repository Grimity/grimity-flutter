// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grimity/app/settings/app_settings.dart';

/// 앱 설정 값을 읽고 변경하며, 변경 사항을 알리는 기본 클래스.
abstract class Setting<T> extends ChangeNotifier {
  new({
    required this.key,
    required this.initialValue,
  });

  /// 설정 항목을 식별하는 키.
  final String key;

  /// 저장된 값이 없거나 유효하지 않을 때 사용할 값.
  final T initialValue;

  /// 설정 값을 변경합니다.
  set value(T newValue);

  /// 현재 설정 값을 반환합니다.
  T get value;

  /// 앱 설정 값을 저장하고 불러오는 로컬 저장소.
  SharedPreferences get prefs => AppSettings.prefs;
}
