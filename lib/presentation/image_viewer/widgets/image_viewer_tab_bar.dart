// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:pervice/pervice.dart';

/// 이미지 뷰어 하단에 썸네일 목록을 표시하고 선택한 이미지로 이동하는 위젯.
class ImageViewerTabBar extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
    required this.imageUrls,
  });

  final TabController controller;
  final List<String> imageUrls;

  /// 썸네일 선택 시 이미지 전환에 적용할 애니메이션.
  static const animation = GdsAnimation.normal;

  @override
  Widget build(BuildContext context) {
    context.watch(controller);
    final images = imageUrls.toImages();
    final tabIndex = controller.index;

    return GdsContainer(
      opacity: .opacity80,
      color: .bgBlack,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: .center,
        indicator: const BoxDecoration(),
        dividerColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        labelPadding: const .symmetric(horizontal: 4), // 간격 8px
        padding: context.whenDevice(
          mobile: .only(top: 8, bottom: 8, left: 12, right: 12),
          tablet: .only(top: 8, bottom: 36, left: 12, right: 12),
        ),

        // 썸네일 목록 표시
        tabs: images.indexedBuilder((index, image) {
          return GdsGesture(
            onTap: () => controller.animateTo(index),
            child: AnimatedOpacity(
              opacity: tabIndex == index ? 1 : 0.5,
              duration: animation.duration,
              curve: animation.curve,
              child: GdsThumbnail(
                width: context.whenDevice(
                  mobile: 64,
                  tablet: 90,
                ),
                ratio: .square,
                radius: .sm,
                provider: image,
              ),
            ),
          );
        }),
      ),
    );
  }
}
