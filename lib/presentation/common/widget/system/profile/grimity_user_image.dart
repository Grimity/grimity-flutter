import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';

class GrimityUserImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final BoxDecoration? decoration;

  const GrimityUserImage({super.key, required this.imageUrl, this.size = 40, this.decoration});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          decoration ??
          BoxDecoration(
            color: AppColor.gray300,
            border: Border.all(color: Colors.white, width: 2),
            shape: BoxShape.circle,
          ),
      child: (imageUrl ?? '').isEmpty == true
          ? CircleAvatar(
              radius: size / 2,
              child: SvgPicture.asset(Assets.icons.icon.defaultProfile.path, width: size),
            )
          : ClipOval(
              child: GrimityCachedNetworkImage.cover(
                imageUrl: imageUrl!,
                width: size,
                height: size,
              ),
            ),
    );
  }
}
