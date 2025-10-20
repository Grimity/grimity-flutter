import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';

class GrimityChip extends StatelessWidget {
  const GrimityChip._({required this.text, required this.backgroundColor, required this.textColor, this.border});

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final BoxBorder? border;

  /// 밝은 칩 (light chip)
  factory GrimityChip.light(String text) {
    return GrimityChip._(
      text: text,
      backgroundColor: AppColor.mainSecondary,
      textColor: AppColor.main,
      border: Border.all(color: const Color(0xFF28C86E).withValues(alpha: 0.3), width: 1),
    );
  }

  /// 어두운 칩 (dark chip)
  factory GrimityChip.dark(String text) {
    return GrimityChip._(text: text, backgroundColor: AppColor.primary1, textColor: AppColor.primary2, border: null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(99), border: border),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Text(text, style: AppTypeface.caption3.copyWith(color: textColor)),
    );
  }
}
