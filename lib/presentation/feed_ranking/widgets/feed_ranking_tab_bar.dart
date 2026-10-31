// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 주간과 월간 인기 그림 랭킹을 전환하는 탭 바 위젯.
class FeedRankingTabBar extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.whenDevice(
        mobile: .symmetric(horizontal: 16),
        tablet: .symmetric(horizontal: 20),
      ),
      child: GdsTabBar(
        controller: controller,
        items: [
          .new(label: '주간'),
          .new(label: '월간'),
        ],
      ),
    );
  }
}
