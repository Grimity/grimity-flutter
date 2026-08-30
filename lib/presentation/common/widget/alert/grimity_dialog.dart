import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

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
    this.linkWidget,
    this.shareWidget,
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

  /// 위젯
  final Widget? linkWidget;
  final Widget? shareWidget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.black.withValues(alpha: 0.4),
      child: Container(
        width: 343,
        padding: EdgeInsets.fromLTRB(16, 30, 16, 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColor.gray00),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!.svg(width: 60, height: 60), Gap(16)],
            Text(
              title,
              style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700),
              textAlign: TextAlign.center,
            ),
            if (content != null) ...[
              Gap(6),
              Text(
                content!,
                style: AppTypeface.label3.copyWith(color: AppColor.gray600),
                textAlign: TextAlign.center,
              ),
            ],
            if (linkWidget != null) ...[Gap(16), linkWidget!],
            Gap(30),
            if (shareWidget != null) ...[shareWidget!, Gap(12)],
            Row(
              spacing: 6,
              children: [
                if (cancelText != null) ...[
                  Expanded(
                    child: GrimityGesture(
                      onTap: onCancel ?? () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: AppColor.gray00,
                          border: Border.all(color: AppColor.gray300),
                          borderRadius: BorderRadius.circular(10),
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
                    child: GrimityGesture(
                      onTap: onConfirm ?? () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(color: AppColor.primary4, borderRadius: BorderRadius.circular(10)),
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
