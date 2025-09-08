import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

class BoardSearchAppBar extends StatelessWidget {
  const BoardSearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      centerTitle: false,
      title: Text('검색', style: AppTypeface.subTitle3.copyWith(color: AppColor.primary4)),
      titleSpacing: 0,
      actions: [
        GestureDetector(onTap: () {}, child: Assets.icons.home.search.svg(width: 24.w, height: 24.w)),
        Gap(20.w),
        GestureDetector(
          onTap: () => Scaffold.of(context).openEndDrawer(),
          child: Assets.icons.home.menu.svg(width: 24.w, height: 24.w),
        ),
      ],
    );
  }
}
