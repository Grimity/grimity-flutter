import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';

class AlbumChip extends StatelessWidget {
  const AlbumChip({super.key, required this.title, this.amount, required this.onTap, this.isSelected = false});

  final String title;
  final String? amount;
  final bool isSelected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.main : AppColor.gray00,
          border: Border.all(color: isSelected ? AppColor.main : AppColor.gray200),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          children: [
            Text(
              title,
              style:
                  isSelected
                      ? AppTypeface.label1.copyWith(color: AppColor.gray00)
                      : AppTypeface.label2.copyWith(color: AppColor.gray700),
            ),
            if (amount != null) ...[
              Gap(4.w),
              Text(
                amount!,
                style: AppTypeface.caption2.copyWith(color: isSelected ? AppColor.gray00 : AppColor.gray600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
