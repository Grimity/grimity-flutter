import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';

class NotificationActionButton extends StatelessWidget {
  const NotificationActionButton({super.key, required this.title, required this.onTap, required this.icon});

  final String title;
  final VoidCallback onTap;
  final GdsIcon icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return GdsGesture(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          icon.build(width: 16, height: 16, color: colors.icon.graySubtle),
          const Gap(GdsSpacing.spacing6),
          Text(title, style: GdsTypography.caption1.copyWith(color: colors.text.grayBold)),
        ],
      ),
    );
  }
}
