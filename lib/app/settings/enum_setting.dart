// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:grimity/app/settings/setting.dart';

/// 열거형 앱 설정 값을 읽고 저장하는 기본 클래스.
class EnumSetting<T extends Enum> extends Setting<T> {
  new({
    required super.key,
    required super.initialValue,
    required this.values,
  });

  final List<T> values;

  @override
  T get value {
    final name = prefs.getString(key);
    for (final option in values) {
      if (option.name == name) return option;
    }

    return initialValue;
  }

  @override
  set value(T newValue) {
    if (value != newValue) {
      prefs.setString(key, newValue.name);
      notifyListeners();
    }
  }
}
