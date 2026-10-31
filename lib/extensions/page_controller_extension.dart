// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';

/// [PageController]에 대한 유틸리티 확장.
extension PageControllerExtension on PageController {
  /// 현재 표시 중인 페이지의 인덱스.
  int get index {
    return hasClients ? (page?.round() ?? initialPage) : 0;
  }
}
