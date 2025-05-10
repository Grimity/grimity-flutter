import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';

class GrimityGrayCircle extends StatelessWidget {
  const GrimityGrayCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Gap(4),
        Container(width: 2, height: 2, decoration: BoxDecoration(color: AppColor.gray400, shape: BoxShape.circle)),
        const Gap(4),
      ],
    );
  }
}
