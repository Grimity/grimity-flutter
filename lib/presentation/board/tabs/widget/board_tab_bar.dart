import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/post_type.enum.dart';

class BoardTabBar extends SliverPersistentHeaderDelegate {
  const BoardTabBar({required this.tabController, required this.tabList});

  final TabController tabController;
  final List<PostType> tabList;

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
        tabs:
            tabList
                .map(
                  (type) => Tab(
                    child: Text(
                      type.typeName,
                      style: AppTypeface.subTitle4.copyWith(
                        color: tabList[tabController.index] == type ? AppColor.gray700 : AppColor.gray600,
                      ),
                    ),
                  ),
                )
                .toList(),
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
