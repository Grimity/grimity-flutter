import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoAssetThumbnailWidget extends StatelessWidget {
  final AssetEntity asset;
  final double size;

  const PhotoAssetThumbnailWidget({super.key, required this.asset, this.size = 128});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asset.thumbnailDataWithSize(ThumbnailSize(size.toInt(), size.toInt())),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover, width: size, height: size);
        }

        return _PhotoAssetThumbnailLoadingWidget();
      },
    );
  }
}

class _PhotoAssetThumbnailLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFF000000).withValues(alpha: 0.02)),
      child: Center(child: Assets.icons.home.image.svg(width: 32, height: 32)),
    );
  }
}
