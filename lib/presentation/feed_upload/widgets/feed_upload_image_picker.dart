import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/gallery/pages/gallery_page.dart';
import 'package:pervice/pervice.dart';

/// 갤러리에서 피드에 첨부할 이미지를 선택하고 목록에 추가하는 위젯.
class FeedUploadImagePicker extends StatelessWidget {
  const new({
    super.key,
    required this.images,
    required this.thumbnail,
  });

  final ValueState<List<ImageProvider>> images;
  final ValueState<ImageProvider?> thumbnail;

  @override
  Widget build(BuildContext context) {
    return GdsAlbumUpload.placeholder(
      size: context.whenDevice(
        mobile: .md,
        tablet: .lg,
      ),
      onTap: () async {
        final newImages = await context.push<List<ImageProvider>?>(
          const GalleryPage(),
        );

        // 갤러리에서 선택한 이미지가 있으면 목록에 추가.
        if (newImages != null && newImages.isNotEmpty) {
          images.addAll(newImages);

          // 대표 이미지가 없으면 선택한 이미지 중에서 지정.
          if (thumbnail.value == null) {
            thumbnail.value = newImages.first;
          }
        }
      },
    );
  }
}
