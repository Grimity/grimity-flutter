// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:photo_view/photo_view.dart';

/// 이미지를 좌우로 넘기고 확대하거나 이동하여 볼 수 있는 위젯.
class ImageViewer extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
    required this.imageUrls,
  });

  final TabController controller;
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    final images = imageUrls.toImages(responsive: false).cast<ResponsiveImage>();

    return PhotoViewGestureDetectorScope(
      axis: .horizontal,
      child: TabBarView(
        clipBehavior: .none,
        controller: controller,
        children: images.builder((image) {
          final scale = PhotoViewComputedScale.contained * 0.999999;

          return PhotoView.customChild(
            childSize: image.size,
            strictScale: true,
            initialScale: scale,
            minScale: scale,
            maxScale: scale * 4,
            backgroundDecoration: const BoxDecoration(color: Colors.transparent),
            child: GdsImage(provider: image, resize: false),
          );
        }),
      ),
    );
  }
}
