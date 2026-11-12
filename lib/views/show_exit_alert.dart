// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 진행 중인 작업을 취소하고 나갈지 확인하는 팝업을 표시합니다.
Future<void> showExitAlert(
  BuildContext context, {
  required String title,
  required String description,
}) async {
  return GdsAlert.show<void>(
    context,
    builder: (context) => GdsAlert(
      title: title,
      description: description,
      primaryButton: .new(
        label: '나가기',
        onTap: () {
          context.pop();
          context.pop();
        },
      ),
      secondaryButton: .new(
        label: '아니요',
        onTap: context.pop,
      ),
    ),
  );
}
