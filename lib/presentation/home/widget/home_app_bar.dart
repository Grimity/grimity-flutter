import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';

import '../../../app/config/app_router.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      centerTitle: false,
      title: Assets.images.logo.svg(width: 90.w, height: 27.h),
      actions: [
        GestureDetector(
            onTap: () => const SearchViewRoute().push(context),
            child: Assets.icons.home.search.svg(width: 24.w, height: 24.w)),
        Gap(20.w),
        GestureDetector(onTap: () {}, child: Assets.icons.home.notification.svg(width: 24.w, height: 24.w)),
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
