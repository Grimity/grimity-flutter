import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grimity/app/extension/image_extension.dart';

class GrimityCachedNetworkImage extends StatelessWidget {
  const GrimityCachedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final double width;
  final double height;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    int? cacheWidth, cacheHeight;

    // 높이 기준으로 캐시 처리(임시)
    if (true) {
      cacheHeight = height.cacheSize(context);
    } else {
      cacheWidth = width.cacheSize(context);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      fit: BoxFit.cover,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
}
