import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';

class GrimityProfileBackgroundImage extends StatelessWidget {
  const GrimityProfileBackgroundImage({super.key, this.url, this.height = 160.0});

  final String? url;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      return CachedNetworkImage(imageUrl: url!, fit: BoxFit.cover, width: double.maxFinite, height: height);
    }

    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      height: height,
      color: AppColor.gray300,
      child: Assets.images.logo.svg(
        width: 126,
        colorFilter: ColorFilter.mode(AppColor.primary5.withValues(alpha: 0.08), BlendMode.srcIn),
      ),
    );
  }
}