// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/image_provider_extension.dart';
import 'package:grimity/presentation/feed_upload/models/feed_upload_model.dart';
import 'package:grimity/presentation/feed_upload/widgets/feed_upload_image_picker.dart';
import 'package:pervice/pervice.dart';

/// 첨부 이미지 목록과 순서 변경, 대표 이미지 선택 및 삭제 기능을 표시하는 위젯.
class FeedUploadImages extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<FeedUploadModel> model;

  @override
  Widget build(BuildContext context) {
    return GdsReorderable(
      axis: .horizontal,
      scroll: true,
      spacing: 16,
      onReorder: (oldIndex, newIndex) {
        final images = model.value.images.toList();
        final image = images.removeAt(oldIndex);
        images.insert(newIndex, image);

        model.value = model.value.copyWith(images: images);
      },
      footer: FeedUploadImagePicker(model: model),
      itemCount: model.value.images.length,
      itemBuilder: (context, index) {
        final image = model.value.images[index];
        final isThumbnail = image == model.value.thumbnail;

        return GdsReorderableLongPressHandle(
          key: ObjectKey(image),
          index: index,
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
                model.value = model.value.copyWith(thumbnail: image);
              }
            },
            onRemove: () {
              final images = model.value.images.toList()..remove(image);

              // 대표 이미지를 삭제한 경우, 남은 이미지가 있으면 대표 이미지 재지정.
              model.value = model.value.copyWith(
                images: images,
                thumbnail: isThumbnail ? images.firstOrNull : model.value.thumbnail,
              );
            },
          ),
        );
      },
    );
  }
}
