import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

class GrimityDialog extends Dialog {
  const GrimityDialog({
    super.key,
    required this.title,
    this.content,
    this.icon,
    this.cancelText,
    this.confirmText,
    this.onCancel,
    this.onConfirm,
  });

  /// 본문
  final String title;
  final String? content;
  final SvgGenImage? icon;

  /// 버튼 텍스트
  final String? cancelText;
  final String? confirmText;

  /// 버튼 콜백
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.black.withValues(alpha: 0.4),
      child: Container(
        width: 343.w,
        padding: EdgeInsets.fromLTRB(16.w, 30.w, 16.w, 16.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r), color: AppColor.gray00),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!.svg(width: 60.w, height: 60.w), Gap(16.h)],
            Text(title, style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700), textAlign: TextAlign.center),
            if (content != null) ...[
              Gap(6.h),
              Text(content!, style: AppTypeface.label3.copyWith(color: AppColor.gray600), textAlign: TextAlign.center),
            ],
            Gap(30.h),
            Row(
              spacing: 6.w,
              children: [
                if (cancelText != null) ...[
                  Expanded(
                    child: GestureDetector(
                      onTap: onCancel ?? () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        decoration: BoxDecoration(
                          color: AppColor.gray00,
                          border: Border.all(color: AppColor.gray300),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: Text(cancelText!, style: AppTypeface.label2.copyWith(color: AppColor.primary5)),
                        ),
                      ),
                    ),
                  ),
                ],
                if (confirmText != null) ...[
                  Expanded(
                    child: GestureDetector(
                      onTap: onConfirm ?? () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        decoration: BoxDecoration(color: AppColor.primary4, borderRadius: BorderRadius.circular(10.r)),
                        child: Center(
                          child: Text(confirmText!, style: AppTypeface.label2.copyWith(color: AppColor.gray00)),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
