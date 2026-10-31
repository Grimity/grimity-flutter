// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 프로필의 콘텐츠 탭을 표시하는 위젯.
class ProfileTabBar extends StatelessWidget {
  const new({
    super.key,
    required this.views,
    required this.controller,
  });

  final TabController controller;
  final List<GdsTabView> views;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.whenDevice(
        mobile: 16.horizontal,
        tablet: 20.horizontal,
      ),
      child: GdsTabBar(
        items: views.items,
        controller: controller,
      ),
    );
  }
}
