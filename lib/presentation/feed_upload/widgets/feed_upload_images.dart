import 'package:flexible_horizontal_list_view/flexible_horizontal_list_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/image_provider_extension.dart';
import 'package:grimity/presentation/feed_upload/models/feed_upload_model.dart';
import 'package:grimity/presentation/feed_upload/widgets/feed_upload_image_picker.dart';
import 'package:pervice/pervice.dart';

/// 첨부 이미지 목록과 대표 이미지 선택 및 삭제 기능을 표시하는 위젯.
class FeedUploadImages extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<FeedUploadModel> model;

  @override
  Widget build(BuildContext context) {
    final data = model.value;

    return HorizontalListView.separated(
      separatorBuilder: (_, _) => const Gap(16),
      clipBehavior: .none,

      // 대용량 이미지로 인한 성능 이슈로 0 픽셀로 조정.
      cacheExtent: 0,
      itemCount: data.images.length + 1,
      itemBuilder: (context, index) {
        if (data.images.length == index) {
          return FeedUploadImagePicker(model: model);
        }

        final image = data.images[index];
        final isThumbnail = image == data.thumbnail;

        return GdsAlbumUpload.image(
          key: ObjectKey(image),
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
              model.value = data.copyWith(thumbnail: image);
            }
          },
          onRemove: () {
            final images = data.images.toList()..remove(image);

            // 대표 이미지를 삭제한 경우, 남은 이미지가 있으면 대표 이미지 재지정.
            model.value = data.copyWith(
              images: images,
              thumbnail: isThumbnail ? images.firstOrNull : data.thumbnail,
            );
          },
        );
      },
    );
  }
}
