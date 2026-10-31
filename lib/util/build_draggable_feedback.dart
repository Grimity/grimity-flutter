// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';

/// 순서 변경 위젯의 드래그 피드백 빌더로 사용하며, 배경과 그림자 없이 표시합니다.
Widget buildDraggableFeedback(
  BuildContext context,
  BoxConstraints constraints,
  Widget child,
) {
  return ConstrainedBox(
    constraints: constraints,
    child: child,
  );
}
