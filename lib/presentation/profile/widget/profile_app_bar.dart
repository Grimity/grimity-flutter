import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key, required this.userName, required this.nameOpacity, required this.isMine});

  final String userName;
  final double nameOpacity;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: _ProfileAppBarDelegate(name: userName, nameOpacity: nameOpacity, isMine: isMine),
    );
  }
}

class _ProfileAppBarDelegate extends SliverPersistentHeaderDelegate {
  const _ProfileAppBarDelegate({required this.name, required this.nameOpacity, required this.isMine});

  final String name;
  final double nameOpacity;
  final bool isMine;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (!isMine) ...[
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.arrow_back_ios_new_outlined, size: 24.w),
            ),
            Gap(4.w),
          ],
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: nameOpacity,
              child: Text(name, style: AppTypeface.subTitle2, overflow: TextOverflow.ellipsis),
            ),
          ),
          const Spacer(),
          if (isMine) ...[
            GestureDetector(onTap: () {}, child: Assets.icons.home.search.svg(width: 24.w, height: 24.w)),
            Gap(20.w),
            GestureDetector(onTap: () {}, child: Assets.icons.profile.storage.svg(width: 24.w, height: 24.w)),
            Gap(20.w),
            GestureDetector(onTap: () {}, child: Assets.icons.profile.setting.svg(width: 24.w, height: 24.w)),
            Gap(16.w),
          ] else ...[
            GestureDetector(onTap: () {}, child: Assets.icons.home.search.svg(width: 24.w, height: 24.w)),
            Gap(20.w),
            GestureDetector(onTap: () {}, child: Assets.icons.home.menu.svg(width: 24.w, height: 24.w)),
            Gap(20.w),
          ],
        ],
      ),
    );
  }

  @override
  double get maxExtent => AppTheme.kToolbarHeight.height;

  @override
  double get minExtent => AppTheme.kToolbarHeight.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
