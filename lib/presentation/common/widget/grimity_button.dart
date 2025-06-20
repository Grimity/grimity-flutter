import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';

class GrimityButton extends StatelessWidget {
  const GrimityButton(this.text, {super.key, required this.onTap, this.isEnabled = true, this.hasBottomPadding = true});

  final String text;
  final VoidCallback onTap;

  final bool isEnabled;
  final bool hasBottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: hasBottomPadding ? 24.h : 0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isEnabled ? AppColor.primary4 : AppColor.gray300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTypeface.subTitle4.copyWith(color: isEnabled ? Colors.white : AppColor.gray500),
            ),
          ),
        ),
      ),
    );
  }
}
