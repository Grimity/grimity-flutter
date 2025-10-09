import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/gen/assets.gen.dart';

class GrimityToast extends StatelessWidget {
  const GrimityToast({super.key, required this.message, required this.type});

  /// 토스트 메시지
  final String message;

  /// 토스트 타입
  final GrimityToastType type;

  @override
  Widget build(BuildContext context) {
    final icon = type == GrimityToastType.verbose ? Assets.icons.common.successSmall : Assets.icons.common.cautionSmall;
    final backgroundColor =
        type == GrimityToastType.verbose
            ? AppColor.primary4.withValues(alpha: 0.8)
            : AppColor.statusNegative.withValues(alpha: 0.8);

    return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: backgroundColor),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon.svg(width: 16.w, height: 16.w),
              SizedBox(width: 8.w),
              Text(message, style: AppTypeface.caption1.copyWith(color: Colors.white)),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 200))
        .move(
          begin: const Offset(0, -10),
          end: const Offset(0, 30),
          curve: Curves.easeOutBack,
          duration: const Duration(milliseconds: 300),
        )
        .then(delay: const Duration(seconds: 1))
        .fadeOut(duration: const Duration(milliseconds: 300));
  }
}
