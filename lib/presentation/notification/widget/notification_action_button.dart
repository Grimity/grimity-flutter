import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

class NotificationActionButton extends StatelessWidget {
  const NotificationActionButton({super.key, required this.title, required this.onTap, required this.icon});

  final String title;
  final VoidCallback onTap;
  final SvgGenImage icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          icon.svg(width: 16, height: 16),
          Gap(6),
          Text(title, style: AppTypeface.caption2.copyWith(color: AppColor.gray700)),
        ],
      ),
    );
  }
}
