import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/user.dart';

class ProfileTabBar extends SliverPersistentHeaderDelegate {
  const ProfileTabBar({required this.user, required this.tabController, this.isMine = false});

  final User user;
  final TabController tabController;
  final bool isMine;

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
          _ProfileTab(name: '그림', count: user.feedCount ?? 0),
          if (isMine) _ProfileTab(name: '글', count: user.postCount ?? 0),
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

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.name, required this.count});

  final String name;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: AppTypeface.subTitle4.copyWith(color: AppColor.gray700)),
          Text('$count', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
        ],
      ),
    );
  }
}
