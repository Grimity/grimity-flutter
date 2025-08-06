import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

class RankingAppBar extends StatelessWidget {
  const RankingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      centerTitle: false,
      title: Text('랭킹', style: AppTypeface.subTitle3.copyWith(color: AppColor.primary4),),
      actions: [
        GestureDetector(onTap: () {}, child: Assets.icons.home.search.svg(width: 24.w, height: 24.w)),
        Gap(20.w),
        GestureDetector(
          onTap: () => Scaffold.of(context).openEndDrawer(),
          child: Assets.icons.home.menu.svg(width: 24.w, height: 24.w),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.gray300),
      ),
    );
  }
}