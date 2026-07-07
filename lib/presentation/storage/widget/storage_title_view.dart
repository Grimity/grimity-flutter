import 'package:flutter/material.dart';
import 'package:gds/gds.dart';

class StorageTitleView extends StatelessWidget {
  const StorageTitleView({super.key});

  static const EdgeInsets _mobilePadding = EdgeInsets.only(
    top: GdsSpacing.spacing16,
    left: GdsSpacing.spacing16,
    right: GdsSpacing.spacing16,
    bottom: GdsSpacing.spacing12,
  );

  static const EdgeInsets _tabletPadding = EdgeInsets.symmetric(
    vertical: GdsSpacing.spacing24,
    horizontal: GdsSpacing.spacing20,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return Padding(
      padding: context.isMobile ? _mobilePadding : _tabletPadding,
      child: Row(
        children: [
          Text(
            '내 보관함',
            style:
                context.isMobile
                    ? GdsTypography.title2.copyWith(color: colors.text.grayBold)
                    : GdsTypography.title1.copyWith(color: colors.text.grayBold),
          ),
        ],
      ),
    );
  }
}
