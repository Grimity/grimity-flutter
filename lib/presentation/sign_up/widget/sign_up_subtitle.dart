import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';

class SignUpSubtitle extends StatelessWidget {
  const SignUpSubtitle({super.key, required this.subtitle, required this.description});

  final String subtitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: GdsSpacing.spacing12,
      children: [
        Text(
          subtitle,
          style: context.isMobile
              ? GdsTypography.title2.copyWith(color: colors.text.grayBold)
              : GdsTypography.title1.copyWith(color: colors.text.grayBold),
        ),
        Text(
          description,
          style: GdsTypography.body1R.copyWith(color: colors.text.grayBold),
        ),
      ],
    );
  }
}
