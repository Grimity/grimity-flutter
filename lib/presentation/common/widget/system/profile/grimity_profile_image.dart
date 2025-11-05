import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';

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
                child: GrimityCachedNetworkImage(imageUrl: url!, width: 80, height: 80),
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
