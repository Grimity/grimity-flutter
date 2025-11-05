import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';

class GrimityProfileBackgroundImage extends StatelessWidget {
  const GrimityProfileBackgroundImage({super.key, this.url, this.height = 160.0});

  final String? url;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      return GrimityCachedNetworkImage(imageUrl: url!, width: double.infinity, height: height);
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
