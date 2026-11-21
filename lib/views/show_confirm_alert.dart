// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 정말로 작업을 진행할 것인지 추가 확인하는 팝업을 표시합니다.
Future<bool?> showConfirmAlert(
  BuildContext context, {
  required String label,
  required String title,
  required String description,
}) async {
  return GdsAlert.show<bool>(
    context,
    builder: (context) {
      return GdsAlert(
        title: title,
        description: description,
        primaryButton: .new(
          label: label,
          onTap: () => context.pop(true),
        ),
        secondaryButton: .new(
          label: '아니요',
          onTap: () => context.pop(false),
        ),
      );
    },
  );
}
