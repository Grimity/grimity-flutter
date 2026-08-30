import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/photo_album.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/photo_select/widget/photo_asset_thumbnail_widget.dart';

/// 앨범 목록(앨범명 + 사진 수 + 대표 썸네일) 뷰.
/// 상단 앨범명 화살표를 눌렀을 때 노출됩니다.
class PhotoAlbumListView extends StatelessWidget {
  const PhotoAlbumListView({super.key, required this.albums, required this.onAlbumTap});

  final List<PhotoAlbum> albums;
  final ValueChanged<PhotoAlbum> onAlbumTap;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.gdsColors.surface.base,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return _PhotoAlbumTile(album: album, onTap: () => onAlbumTap(album));
        },
      ),
    );
  }
}

class _PhotoAlbumTile extends StatelessWidget {
  const _PhotoAlbumTile({required this.album, required this.onTap});

  static const double _thumbnailSize = 48;

  final PhotoAlbum album;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.gdsColors;

    return GdsGesture(
      onTap: onTap,
      child: Container(
        color: color.surface.base,
        padding: const EdgeInsets.symmetric(
          horizontal: GdsSpacing.spacing16,
          vertical: GdsSpacing.spacing10,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(GdsRadius.xs),
              child: SizedBox(
                width: _thumbnailSize,
                height: _thumbnailSize,
                child: album.cover != null
                    ? PhotoAssetThumbnailWidget(asset: album.cover!, size: 144)
                    : _PhotoAlbumThumbnailPlaceholder(),
              ),
            ),
            const SizedBox(width: GdsSpacing.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    album.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GdsTypography.label3.copyWith(color: color.text.grayBold),
                  ),
                  Text(
                    '${album.count}개 사진',
                    style: GdsTypography.label6.copyWith(color: color.text.graySubtle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoAlbumThumbnailPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = context.gdsColors;
    return Container(
      decoration: BoxDecoration(color: color.surface.base),
      child: Center(child: Assets.icons.icon.imagePlaceholder.svg(width: 24, height: 24)),
    );
  }
}
