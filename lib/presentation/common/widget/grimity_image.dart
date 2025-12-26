import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';

class GrimityImage extends StatelessWidget {
  const GrimityImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.index,
  });

  const GrimityImage.big({
    super.key,
    required this.imageUrl,
    this.index,
  }) : width = 205,
       height = 205;

  const GrimityImage.medium({
    super.key,
    required this.imageUrl,
    this.index,
  }) : width = 165,
       height = 165;

  const GrimityImage.small({
    super.key,
    required this.imageUrl,
    this.index,
  }) : width = 130,
       height = 130;

  const GrimityImage.infinity({
    super.key,
    required this.imageUrl,
    this.index,
  }) : width = double.infinity,
       height = double.infinity;

  final String imageUrl;
  final double width;
  final double height;

  final int? index;

  @override
  Widget build(BuildContext context) {
    if (width.isInfinite || height.isInfinite) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return buildImageWidget(
            constraints.maxWidth,
            constraints.maxHeight,
          );
        },
      );
    }

    return buildImageWidget(width, height);
  }

  Widget buildImageWidget(double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          GrimityCachedNetworkImage.cover(
            imageUrl: imageUrl,
            width: width,
            height: height,
          ),
          if (index != null && index! <= 3) ...[
            Positioned.fill(
              left: 10,
              top: 10,
              child: Align(
                alignment: Alignment.topLeft,
                child: switch (index!) {
                  0 => Assets.icons.home.ranking1.svg(width: 26, height: 26),
                  1 => Assets.icons.home.ranking2.svg(width: 26, height: 26),
                  2 => Assets.icons.home.ranking3.svg(width: 26, height: 26),
                  3 => Assets.icons.home.ranking4.svg(width: 26, height: 26),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
