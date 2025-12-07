import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grimity/app/extension/image_extension.dart';
import 'package:grimity/app/extension/string_extension.dart';
import 'package:grimity/gen/assets.gen.dart';

class GrimityCachedNetworkImage extends StatelessWidget {
  const GrimityCachedNetworkImage.cover({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  }) : fit = BoxFit.cover;

  const GrimityCachedNetworkImage.fitWidth({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  }) : fit = BoxFit.fitWidth;

  const GrimityCachedNetworkImage.fitHeight({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  }) : fit = BoxFit.fitHeight;

  const GrimityCachedNetworkImage.contain({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  }) : fit = BoxFit.contain;

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double? width = this.width;
        double? height = this.height;

        // 주어진 가로 크기가 무한이라면 부모의 제약 조건을 따름.
        if (width?.isInfinite ?? false == true) {
          width = constraints.maxWidth;
        }

        // 주어진 세로 크기가 무한이라면 부모의 제약 조건을 따름.
        if (height?.isInfinite ?? false == true) {
          height = constraints.maxHeight;
        }

        int? cacheWidth, cacheHeight;

        assert(width?.isFinite ?? true, "주어진 이미지 크기가 무한이 될 수 있으려면 부모의 유한한 제약 조건이 필요합니다.");
        assert(height?.isFinite ?? true, "주어진 이미지 크기가 무한이 될 수 있으려면 부모의 유한한 제약 조건이 필요합니다.");

        switch (fit) {
          // [BoxFit.cover]인 경우 짧은 변 기준으로 캐싱 처리
          case BoxFit.cover:
            final originSize = imageUrl.getImageSize();
            if (originSize == null) {
              // 사이즈를 파싱할 수 없으면 높이 기준
              cacheHeight = height?.cacheSize(context);
            } else {
              final isLandscape = originSize.width > originSize.height;
              if (isLandscape) {
                cacheHeight = height?.cacheSize(context);
              } else {
                cacheWidth = width?.cacheSize(context);
              }
            }
            break;

          // [BoxFit.fitWidth]인 경우 Width 기준으로 캐싱 처리
          case BoxFit.fitWidth:
            cacheWidth = width?.cacheSize(context);
            break;

          // [BoxFit.fitHeight]인 경우 Height 기준으로 캐싱 처리
          case BoxFit.fitHeight:
            cacheHeight = height?.cacheSize(context);
            break;

          // [BoxFit.contain]인 경우 긴 변 기준으로 캐싱
          case BoxFit.contain:
            final originSize = imageUrl.getImageSize();
            if (originSize == null) {
              // 사이즈를 파싱할 수 없으면 높이 기준
              cacheHeight = height?.cacheSize(context);
            } else {
              final isLandscape = originSize.width > originSize.height;
              if (isLandscape) {
                cacheWidth = width?.cacheSize(context);
              } else {
                cacheHeight = height?.cacheSize(context);
              }
            }
            break;

          default:
            break;
        }

        return CachedNetworkImage(
          imageUrl: imageUrl.getResizeUrl(cacheWidth ?? cacheHeight ?? 0),
          width: width,
          height: height,
          memCacheWidth: cacheWidth,
          memCacheHeight: cacheHeight,
          fit: fit,
          placeholder: placeholder ?? defaultPlaceholder,
          errorWidget: errorWidget ?? defaultErrorWidget,
          fadeInDuration: Duration(milliseconds: 300),
          fadeInCurve: Curves.easeInOut,
          fadeOutDuration: Duration(milliseconds: 300),
          fadeOutCurve: Curves.easeInOut,
          placeholderFadeInDuration: Duration(milliseconds: 300),
        );
      },
    );
  }

  /// [CachedNetworkImage]에 대한 [placeholder]의 기본 빌더입니다.
  Widget defaultPlaceholder(BuildContext context, String imageUrl) {
    final Widget child = Assets.images.imagePlaceholder.image(
      width: width,
      height: height,
      fit: BoxFit.cover,
    );

    final imageSize = imageUrl.getImageSize();

    return SizedBox(
      width: width,
      height: height,
      child: imageSize != null ? AspectRatio(aspectRatio: imageSize.aspectRatio, child: child) : child,
    );
  }

  /// [CachedNetworkImage]에 대한 [errorWidget]의 기본 빌더입니다.
  Widget defaultErrorWidget(BuildContext context, String imageUrl, Object _) {
    return defaultPlaceholder(context, imageUrl);
  }
}
