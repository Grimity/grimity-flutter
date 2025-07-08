import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/user.dart';

class ProfileTabBar extends SliverPersistentHeaderDelegate {
  const ProfileTabBar({required this.user, required this.tabController});

  final User user;
  final TabController tabController;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        labelColor: AppColor.gray800,
        unselectedLabelColor: AppColor.gray600,
        labelStyle: AppTypeface.label1,
        unselectedLabelStyle: AppTypeface.label1,
        indicator: BoxDecoration(shape: BoxShape.rectangle, color: AppColor.gray800),
        indicatorPadding: EdgeInsets.only(top: 39.w),
        indicatorColor: AppColor.gray800,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: AppColor.gray300,
        padding: EdgeInsets.zero,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        physics: const NeverScrollableScrollPhysics(),
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(4),
                Text('그림', style: AppTypeface.subTitle4.copyWith(color: AppColor.gray700)),
                Gap(4),
                Text('${user.feedCount ?? 0}', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                Gap(4),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(4),
                Text('글', style: AppTypeface.subTitle4.copyWith(color: AppColor.gray700)),
                Gap(4),
                Text('${user.postCount ?? 0}', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                Gap(4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 42.w;

  @override
  double get minExtent => 42.w;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
