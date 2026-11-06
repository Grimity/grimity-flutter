// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

/// 이미지를 확대하거나 이동하여 지정한 모양과 비율로 자르는 모달을 엽니다.
Future<ImageProvider?> showImageCropModal(
  BuildContext context, {
  required String title,
  required String label,
  required AssetEntityImageProvider provider,
  required GdsThumbnailRatio ratio,
  required BoxShape shape,
}) {
  return GdsModal.show<ImageProvider>(
    context,
    builder: (context) {
      final controller = context.useCustomImageCropController();

      return GdsModal(
        onBack: context.pop,
        title: title,
        primaryButton: .new(
          label: label,
          onTap: () async {
            final image = await controller.onCropImage();

            // 이미지를 자르고 나서 결과를 반환하고 모달 닫기.
            if (context.mounted && image != null) {
              context.pop(image);
            }
          },
        ),
        child: AspectRatio(
          aspectRatio: provider.entity.orientatedSize.aspectRatio,
          child: GdsImageCropper(
            aspectRatio: ratio.value,
            shape: shape,
            provider: provider,
            controller: controller,
          ),
        ),
      );
    },
  );
}
