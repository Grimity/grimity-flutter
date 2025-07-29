import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';

/// 댓글이 없는 경우
class EmptyCommentWidget extends StatelessWidget {
  const EmptyCommentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Column(
        children: [
          Assets.icons.common.commentReply.svg(width: 60.w, height: 60.w),
          Gap(16),
          Text('아직 댓글이 없어요', style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700)),
          Gap(6),
          Text('댓글을 써서 생각을 나눠보세요', style: AppTypeface.label2.copyWith(color: AppColor.gray500)),
        ],
      ),
    );
  }
}
