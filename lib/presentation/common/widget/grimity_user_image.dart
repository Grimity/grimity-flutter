import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GrimityUserImage extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const GrimityUserImage({super.key, required this.imageUrl, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.gray300,
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child:
          (imageUrl ?? '').isEmpty == true
              ? CircleAvatar(
                radius: size / 2,
                child: SvgPicture.asset(Assets.icons.main.defaultProfile.path, width: size),
              )
              : ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Skeletonizer(child: SizedBox(width: size, height: size)),
                  errorWidget: (context, url, error) => Assets.images.imagePlaceholder.image(width: size, height: size),
                ),
              ),
    );
  }
}
