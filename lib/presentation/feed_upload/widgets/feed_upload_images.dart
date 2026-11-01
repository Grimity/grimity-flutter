// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/image_provider_extension.dart';
import 'package:grimity/presentation/feed_upload/models/feed_upload_model.dart';
import 'package:grimity/presentation/feed_upload/widgets/feed_upload_image_picker.dart';
import 'package:grimity/util/build_draggable_feedback.dart';
import 'package:pervice/pervice.dart';
import 'package:reorderables/reorderables.dart';

/// 첨부 이미지 목록과 순서 변경, 대표 이미지 선택 및 삭제 기능을 표시하는 위젯.
class FeedUploadImages extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<FeedUploadModel> model;

  @override
  Widget build(BuildContext context) {
    return ReorderableRow(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      ignorePrimaryScrollController: true,
      onReorder: (oldIndex, newIndex) {
        // 드래그한 순서로 이미지 목록 갱신.
        final images = model().images.toList();
        final image = images.removeAt(oldIndex);
        images.insert(newIndex, image);

        model.set(model().copyWith(images: images));
      },
      buildDraggableFeedback: buildDraggableFeedback,
      footer: FeedUploadImagePicker(model: model),
      children: model().images.builder((image) {
        final isThumbnail = image == model().thumbnail;

        return Padding(
          key: ObjectKey(image),
          padding: .only(right: 16),
          child: GdsAlbumUpload.image(
            size: context.whenDevice(
              mobile: .md,
              tablet: .lg,
            ),
            image: image,
            title: image.displayName,
            checked: isThumbnail,
            onTap: () {
              // 해당 이미지를 대표 이미지로 지정.
              if (!isThumbnail) {
                model.set(model().copyWith(thumbnail: image));
              }
            },
            onRemove: () {
              final images = model().images.toList()..remove(image);

              // 대표 이미지를 삭제한 경우, 남은 이미지가 있으면 대표 이미지 재지정.
              model.set(
                model().copyWith(
                  images: images,
                  thumbnail: isThumbnail ? images.firstOrNull : model().thumbnail,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
