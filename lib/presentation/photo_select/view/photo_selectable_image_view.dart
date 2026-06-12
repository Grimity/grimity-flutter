import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/extension/build_context_extension.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_provider.dart';
import 'package:grimity/presentation/photo_select/widget/photo_asset_thumbnail_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

/// 선택할 수 있는 이미지 ListView
class PhotoSelectableGridView extends StatelessWidget {
  final List<ImageSourceItem> selectedImages;
  final List<AssetEntity> galleryImages;

  const PhotoSelectableGridView({
    super.key,
    required this.selectedImages,
    required this.galleryImages,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.photoRowCount,
        crossAxisSpacing: GdsSpacing.spacing2,
        mainAxisSpacing: GdsSpacing.spacing2,
      ),
      itemBuilder: (context, index) {
        final asset = galleryImages[index];
        final isSelected = selectedImages.contains(ImageSourceItem.asset(asset));
        final selectionIndex = selectedImages.indexOf(ImageSourceItem.asset(asset)) + 1;

        return _PhotoSelectableImageThumbnail(
          asset: asset,
          isSelected: isSelected,
          selectionIndex: selectionIndex,
        );
      },
      itemCount: galleryImages.length,
    );
  }
}

class _PhotoSelectableImageThumbnail extends ConsumerWidget with PhotoSelectMixin {
  final AssetEntity asset;
  final bool isSelected;
  final int? selectionIndex;

  const _PhotoSelectableImageThumbnail({
    required this.asset,
    required this.isSelected,
    this.selectionIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GdsGesture(
      onTap: () => photoNotifier(ref).toggleImageSelection(ImageSourceItem.asset(asset)),
      child: isSelected ? _buildSelectedThumbnail(context) : PhotoAssetThumbnailWidget(asset: asset),
    );
  }

  /// 선택된 이미지는 라운드 처리 후 상단 그라데이션과 선택 순서 뱃지를 표시합니다.
  Widget _buildSelectedThumbnail(BuildContext context) {
    final colors = context.gdsColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(GdsRadius.md),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PhotoAssetThumbnailWidget(asset: asset),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.surface.black.withValues(alpha: GdsOpacity.opacity40),
                  GdsColors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            top: GdsSpacing.spacing8,
            right: GdsSpacing.spacing8,
            child: GdsNumberPushBadge.text(count: selectionIndex ?? 0),
          ),
        ],
      ),
    );
  }
}
