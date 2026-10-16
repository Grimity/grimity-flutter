import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

/// 선택 가능한 갤러리 이미지와 그에 따른 선택 순서를 표시하는 위젯.
class GalleryImage extends StatelessWidget {
  const new({
    super.key,
    required this.asset,
    required this.selectedIndex,
    required this.onAdd,
    required this.onRemove,
  });

  final AssetEntity asset;
  final int selectedIndex;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex >= 0;

    return GdsAlbumUpload.album(
      image: AssetEntityImageProvider(
        asset,
        isOriginal: false,
        thumbnailSize: const .square(400),
      ),
      count: selectedIndex + 1,
      checked: isSelected,
      onTap: isSelected ? onRemove : onAdd,
    );
  }
}
