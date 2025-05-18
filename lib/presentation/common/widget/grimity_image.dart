import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GrimityImage extends StatelessWidget {
  const GrimityImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.index,
    this.isLike,
  });

  const GrimityImage.big({super.key, required this.imageUrl, this.index, this.isLike}) : width = 205, height = 205;
  const GrimityImage.medium({super.key, required this.imageUrl, this.index, this.isLike}) : width = 165, height = 165;

  final String imageUrl;
  final double width;
  final double height;

  final int? index;
  final bool? isLike;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder:
            (context, imageProvider) => Stack(
              children: [
                Positioned.fill(child: Image(image: imageProvider, fit: BoxFit.cover)),
                if (isLike != null) ...[
                  Positioned.fill(
                    right: 10,
                    bottom: 10,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GrimityAnimationButton(
                        onTap: () {},
                        child:
                            isLike!
                                ? Assets.icons.home.heartFill.svg(width: 24, height: 24)
                                : Assets.icons.home.heart.svg(width: 24, height: 24),
                      ),
                    ),
                  ),
                ],
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
        placeholder: (context, url) => Skeletonizer(child: SizedBox(width: width, height: height)),
        errorWidget: (context, error, stackTrace) => Assets.images.imagePlaceholder.image(width: width, height: height),
      ),
    );
  }
}
