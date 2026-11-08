// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/image_viewer/views/image_viewer.dart';
import 'package:grimity/presentation/image_viewer/widgets/image_viewer_app_bar.dart';
import 'package:grimity/presentation/image_viewer/widgets/image_viewer_tab_bar.dart';
import 'package:pervice/pervice.dart';

/// 이미지 확대 및 축소와 좌우 탐색, 썸네일 선택을 지원하는 이미지 뷰어 페이지.
class ImageViewerPage extends StatelessWidget {
  const new({
    super.key,
    required this.imageUrls,
    required this.index,
    required this.canDownload,
  });

  final List<String> imageUrls;
  final int index;
  final bool canDownload;

  @override
  Widget build(BuildContext context) {
    final controller = context.useTabController(
      initialIndex: index,
      length: imageUrls.length,
    );

    return GdsScaffold(
      backgroundColor: .bgBlack,
      body: Stack(
        children: [
          // 이미지 목록 표시
          ImageViewer(
            controller: controller,
            imageUrls: imageUrls,
          ),

          // 상단 네비게이션 표시
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ImageViewerAppBar(
              imageUrls: imageUrls,
              controller: controller,
              canDownload: canDownload,
            ),
          ),

          // 하단에 썸네일 스트립 표시
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ImageViewerTabBar(
              controller: controller,
              imageUrls: imageUrls,
            ),
          ),
        ],
      ),
    );
  }
}
