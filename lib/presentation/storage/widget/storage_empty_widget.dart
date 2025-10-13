import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

class StorageEmptyWidget extends StatelessWidget {
  const StorageEmptyWidget({super.key, required this.emptyMessage});

  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        spacing: 16,
        children: [
          SvgPicture.asset(Assets.icons.common.resultNull.path, width: 60.w),
          Text(emptyMessage, style: AppTypeface.label2.copyWith(color: AppColor.gray600)),
        ],
      ),
    );
  }
}
