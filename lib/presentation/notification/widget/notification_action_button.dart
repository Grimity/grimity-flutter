import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

class NotificationActionButton extends StatelessWidget {
  const NotificationActionButton({super.key, required this.title, required this.onTap, required this.icon});

  final String title;
  final VoidCallback onTap;
  final SvgGenImage icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return GrimityGesture(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title, style: AppTypeface.label1.copyWith(color: colors.text.graySubtler)),
          Gap(6),
          icon.svg(
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              colors.icon.graySubtler,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
