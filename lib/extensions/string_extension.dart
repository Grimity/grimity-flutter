// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

/// [String]에 대한 유틸리티 확장.
extension StringExtension on String {
  /// 이메일 주소인지 여부.
  bool get isEmail {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(this);
  }

  /// 빈 문자열이면 null을, 아니면 문자열을 그대로 반환합니다.
  String? get orNull {
    return isEmpty ? null : this;
  }
}
