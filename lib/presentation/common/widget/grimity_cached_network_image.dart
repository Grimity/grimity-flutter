import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grimity/app/extension/image_extension.dart';
import 'package:grimity/app/extension/string_extension.dart';

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
            final originSize = parseImageSizeFromUrl(imageUrl);
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
            final originSize = parseImageSizeFromUrl(imageUrl);
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
          placeholder: placeholder,
          errorWidget: errorWidget,
          fadeInDuration: Duration(milliseconds: 300),
          fadeInCurve: Curves.easeInOut,
        );
      },
    );
  }

  /// URL 끝에서 `_WIDTHxHEIGHT` 패턴을 찾아 원본 이미지 사이즈를 반환
  /// 예: https://.../image_1300x800.webp → Size(1300, 800)
  ///
  /// 반환값:
  /// - 성공: Size(width, height)
  /// - 실패: null
  Size? parseImageSizeFromUrl(String url) {
    final regex = RegExp(r'_([0-9]+)x([0-9]+)(?:\.[a-zA-Z]+)?(?:\?.*)?$');
    final match = regex.firstMatch(url);

    if (match == null) return null;

    final width = double.tryParse(match.group(1)!);
    final height = double.tryParse(match.group(2)!);

    if (width == null || height == null) return null;
    return Size(width, height);
  }
}
