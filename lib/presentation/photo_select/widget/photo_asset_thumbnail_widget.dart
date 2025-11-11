import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoAssetThumbnailWidget extends StatefulWidget {
  final AssetEntity asset;
  final double size;
  final BoxFit fit;

  const PhotoAssetThumbnailWidget({super.key, required this.asset, this.size = 256, this.fit = BoxFit.cover});

  @override
  State<PhotoAssetThumbnailWidget> createState() => _PhotoAssetThumbnailWidgetState();
}

class _PhotoAssetThumbnailWidgetState extends State<PhotoAssetThumbnailWidget> {
  late Future<Uint8List?> _thumbnailFuture;

  @override
  void initState() {
    super.initState();
    _thumbnailFuture = widget.asset.thumbnailDataWithSize(
      ThumbnailSize(widget.size.toInt(), widget.size.toInt()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data!, fit: widget.fit, width: widget.size, height: widget.size);
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
