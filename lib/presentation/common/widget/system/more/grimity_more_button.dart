import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

/// 공통 더보기 버튼
class GrimityMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool hasDecoration;

  const GrimityMoreButton({super.key, required this.onTap, required this.hasDecoration});

  const GrimityMoreButton.decorated({super.key, required this.onTap}) : hasDecoration = true;

  const GrimityMoreButton.plain({super.key, required this.onTap}) : hasDecoration = false;

  @override
  Widget build(BuildContext context) {
    return GrimityGesture(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration:
            hasDecoration
                ? BoxDecoration(
                  border: Border.all(color: AppColor.gray300, width: 1),
                  borderRadius: BorderRadius.circular(12),
                )
                : null,
        child: Center(child: Assets.icons.common.moreHoriz.svg(width: 20, height: 20)),
      ),
    );
  }
}
