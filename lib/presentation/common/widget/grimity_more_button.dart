import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';

/// 공통 더보기 버튼
class GrimityMoreButton extends StatelessWidget {
  final VoidCallback onTap;

  const GrimityMoreButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.gray300, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: Assets.icons.common.moreHoriz.svg(width: 20, height: 20)),
      ),
    );
  }
}
