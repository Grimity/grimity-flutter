import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/presentation/follow/enum/follow_enum_tab_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grimity/gen/assets.gen.dart';

class FollowEmptyView extends StatelessWidget {
  final FollowTabType type;

  const FollowEmptyView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(80.h),
        SvgPicture.asset(Assets.icons.common.user.path, width: 60.w),
        Gap(16.h),
        Text(type.emptyMessage),
      ],
    );
  }
}
