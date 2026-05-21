import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';

class NotificationActionButton extends StatelessWidget {
  const NotificationActionButton({super.key, required this.title, required this.onTap, required this.icon});

  final String title;
  final VoidCallback? onTap;
  final GdsIcon icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;
    final enabled = onTap != null;
    final textColor = enabled ? colors.text.grayBold : colors.text.graySubtler;
    final iconColor = enabled ? colors.icon.graySubtle : colors.icon.graySubtler;

    return GdsGesture(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          icon.build(width: 16, height: 16, color: iconColor),
          const Gap(GdsSpacing.spacing6),
          Text(title, style: GdsTypography.caption1.copyWith(color: textColor)),
        ],
      ),
    );
  }
}
