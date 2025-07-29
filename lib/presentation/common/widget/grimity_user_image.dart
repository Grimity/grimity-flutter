import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GrimityUserImage extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const GrimityUserImage({super.key, required this.imageUrl, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Color(0xFFDDDDE8), width: 0.3)),
      child:
          (imageUrl ?? '').isEmpty == true
              ? CircleAvatar(radius: size / 2, child: SvgPicture.asset(Assets.icons.main.defaultProfile.path, width: 40))
              : ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Skeletonizer(child: SizedBox(width: 40, height: 40)),
                  errorWidget: (context, url, error) => Assets.images.imagePlaceholder.image(width: 40, height: 40),
                ),
              ),
    );
  }
}
