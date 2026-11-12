// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:grimity/views/show_exit_alert.dart';

/// 변경 사항이 있을 때 나가기 전 확인 팝업을 표시하는 위젯.
class AppExitScope extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.description,
    required this.hasChanges,
    required this.child,
  });

  final String title;
  final String description;
  final bool hasChanges;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // 변경 사항이 남아 있으면 나가기 여부를 확인합니다.
        showExitAlert(
          context,
          title: title,
          description: description,
        );
      },
      child: child,
    );
  }
}
