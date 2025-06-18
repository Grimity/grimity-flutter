import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';

class GrimityProfileBackgroundImage extends StatelessWidget {
  const GrimityProfileBackgroundImage({super.key, this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      return CachedNetworkImage(imageUrl: url!, fit: BoxFit.cover, width: double.maxFinite, height: 160);
    }

    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      height: 160.w,
      color: AppColor.gray300,
      child: Assets.images.logo.svg(
        width: 160,
        colorFilter: ColorFilter.mode(AppColor.primary5.withValues(alpha: 0.08), BlendMode.srcIn),
      ),
    );
  }
}

class GrimityProfileImage extends StatelessWidget {
  const GrimityProfileImage({super.key, this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColor.gray300,
        border: Border.all(color: Colors.white, width: 4),
        shape: BoxShape.circle,
      ),
      child:
          url?.isNotEmpty ?? false
              ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(imageUrl: url!, fit: BoxFit.cover, width: 80, height: 80),
              )
              : Center(
                child: Assets.icons.profile.person.svg(
                  width: 30,
                  height: 30,
                  colorFilter: ColorFilter.mode(AppColor.primary5.withValues(alpha: 0.08), BlendMode.srcIn),
                ),
              ),
    );
  }
}
