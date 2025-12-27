import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/extension/image_extension.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

class _Banner {
  const _Banner({
    required this.asset,
    required this.width,
    required this.height,
  });

  final AssetGenImage asset;
  final double width;
  final double height;
}

class HomeNoticeView extends StatelessWidget {
  const HomeNoticeView({super.key});

  static final small = _Banner(asset: Assets.images.image.noticeBannerSmall, width: 1372, height: 320);
  static final large = _Banner(asset: Assets.images.image.noticeBannerLarge, width: 4380, height: 360);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final banner = width > 700 ? large : small;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GrimityGesture(
            onTap: () => PostDetailRoute(id: AppConst.usageGuidePostId).push(context),
            child: banner.asset.image(
              cacheWidth: banner.width.cacheSize(context),
              cacheHeight: banner.height.cacheSize(context),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
