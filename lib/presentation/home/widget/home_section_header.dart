import 'package:flutter/material.dart';
import 'package:gds/gds.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.onMoreTap,
    this.moreLabel = '더보기',
    this.padding = const EdgeInsets.symmetric(horizontal: GdsSpacing.spacing16),
  });

  final String title;
  final VoidCallback? onMoreTap;
  final String moreLabel;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GdsTypography.subtitle1.copyWith(color: colors.text.grayBold)),
          if (onMoreTap != null)
            GdsGesture(
              onTap: onMoreTap,
              child: Text(
                moreLabel,
                style: GdsTypography.caption1.copyWith(color: colors.text.graySubtle),
              ),
            ),
        ],
      ),
    );
  }
}
