import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_provider.dart';
import 'package:grimity/presentation/photo_select/widget/photo_asset_thumbnail_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

/// 선택할 수 있는 이미지 ListView
class PhotoSelectableGridView extends StatelessWidget {
  final List<ImageSourceItem> selectedImages;
  final List<AssetEntity> galleryImages;

  const PhotoSelectableGridView({super.key, required this.selectedImages, required this.galleryImages});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        final asset = galleryImages[index];
        final isSelected = selectedImages.contains(ImageSourceItem.asset(asset));
        final selectionIndex = selectedImages.indexOf(ImageSourceItem.asset(asset)) + 1;

        return _PhotoSelectableImageThumbnail(asset: asset, isSelected: isSelected, selectionIndex: selectionIndex);
      },
      itemCount: galleryImages.length,
    );
  }
}

class _PhotoSelectableImageThumbnail extends ConsumerWidget with PhotoSelectMixin {
  final AssetEntity asset;
  final bool isSelected;
  final int? selectionIndex;

  const _PhotoSelectableImageThumbnail({required this.asset, required this.isSelected, this.selectionIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GrimityGesture(
      onTap: () => photoNotifier(ref).toggleImageSelection(ImageSourceItem.asset(asset)),
      child: Stack(
        children: [
          PhotoAssetThumbnailWidget(asset: asset),
          if (isSelected)
            Container(
              decoration: BoxDecoration(
                color: AppColor.gray800.withValues(alpha: 0.6),
                border: Border.all(color: AppColor.gray00.withValues(alpha: 0.6), width: 2),
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(color: AppColor.gray00, shape: BoxShape.circle),
              child: isSelected ? Center(child: Text('$selectionIndex', style: AppTypeface.caption1)) : null,
            ),
          ),
        ],
      ),
    );
  }
}
