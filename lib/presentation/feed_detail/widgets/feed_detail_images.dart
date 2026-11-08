// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/image_viewer/pages/image_viewer_page.dart';

/// 피드에 첨부된 이미지를 원본 비율로 세로 목록에 표시하는 위젯.
class FeedDetailImages extends StatelessWidget {
  const new({
    super.key,
    required this.imageUrls,
    required this.isMine,
  });

  final List<String> imageUrls;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      separatorBuilder: (_, _) => const Gap(12),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return GdsGesture(
          onTap: () {
            // 이미지 뷰어 페이지로 이동.
            context.push(
              ImageViewerPage(
                imageUrls: imageUrls,
                index: index,
                canDownload: isMine,
              ),
            );
          },
          child: GdsImage(provider: imageUrls[index].toImage()),
        );
      },
    );
  }
}
