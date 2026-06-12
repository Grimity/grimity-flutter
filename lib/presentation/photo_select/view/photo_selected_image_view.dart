import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_provider.dart';
import 'package:grimity/presentation/photo_select/state/photo_select_state.dart';
import 'package:grimity/presentation/photo_select/widget/photo_asset_thumbnail_widget.dart';

/// 선택된 이미지 표시 ListView
class PhotoSelectedImageListView extends StatelessWidget {
  final PhotoSelectState state;

  const PhotoSelectedImageListView({
    super.key,
    required this.state,
  });

  static const double _itemSize = 72;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.gdsColors.surface.base,
      height: _itemSize + GdsSpacing.spacing12 * 2,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: GdsSpacing.spacing16,
          vertical: GdsSpacing.spacing12,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => _PhotoSelectedImageThumbnail(state.selected[index]),
        separatorBuilder: (context, index) => const SizedBox(width: GdsSpacing.spacing8),
        itemCount: state.selected.length,
      ),
    );
  }
}

class _PhotoSelectedImageThumbnail extends ConsumerWidget with PhotoSelectMixin {
  final ImageSourceItem imageSource;

  const _PhotoSelectedImageThumbnail(this.imageSource);

  static const double _size = PhotoSelectedImageListView._itemSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(GdsRadius.xs),
      child: SizedBox(
        width: _size,
        height: _size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageSource is AssetImageSource
                ? PhotoAssetThumbnailWidget(asset: (imageSource as AssetImageSource).asset, size: 256)
                : GrimityCachedNetworkImage.cover(
                  imageUrl: (imageSource as RemoteImageSource).url,
                  width: _size,
                  height: _size,
                ),
            ColoredBox(color: colors.surface.black.withValues(alpha: GdsOpacity.opacity20)),
            Positioned(
              top: GdsSpacing.spacing2,
              right: GdsSpacing.spacing2,
              child: GdsGesture(
                onTap: () => photoNotifier(ref).removeSelectedImage(imageSource),
                child: Container(
                  width: GdsIconSize.v16,
                  height: GdsIconSize.v16,
                  decoration: BoxDecoration(
                    color: colors.surface.black.withValues(alpha: GdsOpacity.opacity60),
                    borderRadius: BorderRadius.circular(GdsRadius.xs),
                  ),
                  child: GdsIcon.xMark.build(
                    color: colors.icon.white,
                    width: GdsIconSize.v16,
                    height: GdsIconSize.v16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
