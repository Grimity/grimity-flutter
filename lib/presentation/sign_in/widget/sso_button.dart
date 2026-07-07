import 'package:flutter/material.dart';
import 'package:gds/gds.dart';

class SSOButton extends StatelessWidget {
  const SSOButton({
    super.key,
    required this.onTap,
    required this.name,
    required this.icon,
    this.iconColor,
  });

  final VoidCallback onTap;
  final String name;
  final GdsIcon icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return GdsGesture(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: colors.surface.base,
          borderRadius: BorderRadius.circular(GdsRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: GdsSpacing.spacing8,
          children: [
            icon.build(
              width: 24,
              height: 24,
              color: iconColor,
            ),
            Text(
              '$name로 계속하기',
              style: GdsTypography.body1SB.copyWith(color: colors.surface.inverse),
            ),
          ],
        ),
      ),
    );
  }
}
