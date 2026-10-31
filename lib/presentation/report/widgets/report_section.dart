// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 신고 화면의 입력 항목을 섹션으로 묶어 표시하는 위젯.
class ReportSection extends StatelessWidget {
  const new({
    super.key,
    required this.required,
    required this.title,
    required this.child,
  });

  final bool required;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      spacing: 10,
      children: [
        Row(
          spacing: 2,
          children: [
            // 제목 표시
            GdsText(
              title,
              color: .textGrayBold,
              style: .subtitle2,
            ),

            // 필수 여부 표시
            GdsText(
              required ? '(필수)' : '(선택)',
              color: required ? .textPrimaryNormal : .textGraySubtle,
              style: .subtitle2,
            ),
          ],
        ),

        // 본문 표시
        child,
      ],
    );
  }
}
