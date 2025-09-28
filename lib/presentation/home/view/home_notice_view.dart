import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';

class HomeNoticeView extends StatelessWidget {
  const HomeNoticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => PostDetailRoute(id: AppConst.usageGuidePostId).push(context),
        child: Assets.images.noticeBanner.image(),
      ),
    );
  }
}
