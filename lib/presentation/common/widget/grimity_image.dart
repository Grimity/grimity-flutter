import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grimity/app/extension/image_extension.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  final String imageUrl;
  final double width;
  final double height;

  final int? index;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          GrimityCachedNetworkImage.cover(
            imageUrl: imageUrl,
            width: width,
            height: height,
            placeholder: (context, url) => Skeletonizer(child: SizedBox(width: width, height: height)),
            errorWidget:
                (context, url, error) => Assets.images.imagePlaceholder.image(
                  width: width,
                  height: height,
                  cacheWidth: width.cacheSize(context),
                  cacheHeight: height.cacheSize(context),
                ),
          ),
          if (index != null && index! <= 3) ...[
            Positioned.fill(
              left: 10,
              top: 10,
              child: Align(
                alignment: Alignment.topLeft,
                child: SvgPicture.asset('assets/icons/home/ranking_${index! + 1}.svg', width: 26, height: 26),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
