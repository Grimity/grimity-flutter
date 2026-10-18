import 'package:flexible_horizontal_list_view/flexible_horizontal_list_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/image_provider.dart';
import 'package:grimity/presentation/feed_upload/widgets/feed_upload_image_picker.dart';
import 'package:pervice/pervice.dart';

///
class FeedUploadImages extends StatelessWidget {
  const new({
    super.key,
    required this.images,
    required this.thumbnail,
  });

  final ValueState<List<ImageProvider>> images;
  final ValueState<ImageProvider?> thumbnail;

  @override
  Widget build(BuildContext context) {
    return HorizontalListView.separated(
      separatorBuilder: (_, _) => const Gap(16),
      clipBehavior: .none,

      // 대용량 이미지로 인한 성능 이슈로 0 픽셀로 조정.
      cacheExtent: 0,
      itemCount: images.value.length + 1,
      itemBuilder: (context, index) {
        if (images.value.length == index) {
          return FeedUploadImagePicker(
            images: images,
            thumbnail: thumbnail,
          );
        }

        final image = images.value[index];
        final isThumbnail = image == thumbnail.value;

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
              thumbnail.value = image;
            }
          },
          onRemove: () {
            images.remove(image);

            // 대표 이미지를 삭제한 경우, 남은 이미지가 있으면 대표 이미지 재지정.
            if (isThumbnail) {
              thumbnail.value = images.value.firstOrNull;
            }
          },
        );
      },
    );
  }
}
