// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 프로필 콘텐츠의 게시물 개수와 정렬 버튼을 표시하는 도구 모음 위젯.
class ProfileContentToolbar extends StatelessWidget {
  const new({
    super.key,
    required this.count,
    required this.filterBuilder,
    this.actions = const [],
  });

  final int count;
  final GdsPopoverAnchorBuilder filterBuilder;
  final List<GdsTextButtonAction> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        // 게시물 개수 표시
        GdsText.rich(
          TextSpan(
            text: '게시물 ',
            children: [
              GdsTextSpan(
                '$count',
                context,
                color: .textGrayBold,
                style: .label4,
              ),
              const TextSpan(text: '건'),
            ],
          ),
          color: .textGrayNormal,
          style: .label4,
        ),

        Row(
          mainAxisSize: .min,
          spacing: 8,
          children: [
            // 액션 버튼 표시
            ...actions.builder((action) {
              return GdsButton.text(
                size: .md,
                type: .borderless,
                variant: .assistive,
                onTap: action.onTap,
                label: action.label,
                leadingIcon: action.leadingIcon,
                trailingIcon: action.trailingIcon,
                enabled: action.enabled,
              );
            }),

            // 필터 버튼 표시
            GdsPopoverAnchor.builder(builder: filterBuilder),
          ],
        ),
      ],
    );
  }
}
