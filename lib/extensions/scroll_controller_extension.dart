// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// [ScrollController]에 대한 유틸리티 확장.
extension ScrollControllerExtension on ScrollController {
  /// 스크롤 이동에 적용할 애니메이션.
  static const scrollAnimation = GdsAnimation.normal;

  /// 현재 표시 중인 페이지의 인덱스.
  void animateToTop() {
    position.animateTo(
      0,
      duration: scrollAnimation.duration,
      curve: scrollAnimation.curve,
    );
  }
}
