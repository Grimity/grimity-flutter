import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';

class GrimityModalLoading extends StatelessWidget {
  const GrimityModalLoading({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return Container(
      color: colors.bg.overlayBlack.withAlpha((GdsOpacity.opacity40 * 255).toInt()),
      padding: EdgeInsets.all(GdsSpacing.spacing16),
      child: Center(
        child: Material(
          color: colors.surface.base,
          borderRadius: BorderRadius.circular(GdsRadius.xl),
          child: Container(
            width: context.isMobile ? double.infinity : 350,
            padding: EdgeInsets.all(GdsSpacing.spacing40),
            decoration: BoxDecoration(boxShadow: GdsShadows.level2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GdsRefreshLoading(
                  width: GdsSpacing.spacing40,
                  height: GdsSpacing.spacing40,
                ),
                Gap(GdsSpacing.spacing20),
                Text(
                  title,
                  style: GdsTypography.subtitle1.copyWith(color: colors.text.grayBold),
                ),
                Gap(GdsSpacing.spacing10),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GdsTypography.body2R.copyWith(color: colors.text.grayBold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
