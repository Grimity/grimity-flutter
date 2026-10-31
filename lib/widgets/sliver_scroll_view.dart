// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/widgets/sliver_column.dart';

/// 여러 슬리버에 공통 여백과 항목 간 간격을 적용하는 스크롤 위젯.
class SliverScrollView extends StatelessWidget {
  const new({
    super.key,
    this.maxWidth = 0,
    this.spacing = 0,
    this.padding,
    this.controller,
    required this.slivers,
  }) : assert(maxWidth >= 0),
       assert(spacing >= 0);

  final double maxWidth;
  final GdsSpacing spacing;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var padding = this.padding ?? .zero;

        // 최대 너비가 지정된 경우 너비 제한 및 중앙 정렬.
        if (maxWidth > 0) {
          final inset = ((constraints.maxWidth - padding.horizontal - maxWidth) / 2).clamp(0.0, double.infinity);
          padding += .symmetric(horizontal: inset);
        }

        return CustomScrollView(
          // 대용량 이미지로 인한 성능 이슈로 0 픽셀로 조정.
          scrollCacheExtent: .pixels(0),
          controller: controller,
          slivers: [
            SliverPadding(
              padding: padding,
              sliver: SliverColumn(
                spacing: spacing,
                children: slivers,
              ),
            ),
          ],
        );
      },
    );
  }
}
