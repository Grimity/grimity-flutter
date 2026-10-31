// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/widgets/sliver_column.dart';

/// 팔로잉 피드 화면의 섹션 제목과 콘텐츠를 표시하는 위젯.
class FollowingFeedSection extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverColumn(
      spacing: context.whenDevice(
        mobile: 16,
        tablet: 24,
      ),
      children: [
        // 제목 표시
        SliverPadding(
          padding: .only(top: 12),
          sliver: SliverToBoxAdapter(
            child: GdsText(
              title,
              color: .textGrayBold,
              style: context.whenDevice(
                mobile: .title2,
                tablet: .title1,
              ),
            ),
          ),
        ),

        // 본문 표시
        child,
      ],
    );
  }
}
