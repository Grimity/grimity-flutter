import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/extension/image_extension.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

class HomeNoticeView extends StatelessWidget {
  const HomeNoticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GrimityGesture(
        onTap: () => PostDetailRoute(id: AppConst.usageGuidePostId).push(context),
        child: Assets.images.noticeBanner.image(cacheWidth: 343.cacheSize(context), cacheHeight: 80.cacheSize(context)),
      ),
    );
  }
}
