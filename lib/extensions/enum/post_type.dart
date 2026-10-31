// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:grimity/api/api.dart';

/// [PostType]에 대한 유틸리티 확장.
extension PostTypeExtension on PostType {
  /// 게시글 유형의 표시 이름을 반환합니다.
  String get displayName {
    return switch (this) {
      .normal => '일반',
      .question => '질문',
      .feedback => '피드백',
      .notice => '공지',
    };
  }
}
