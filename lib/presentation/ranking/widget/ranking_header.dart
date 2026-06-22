import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:gds/gds.dart';

class RankingHeader extends StatelessWidget {
  const RankingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return Padding(
      padding: EdgeInsets.only(
        top: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing24,
        left: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
        right: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
        bottom: context.isMobile ? GdsSpacing.spacing20 : GdsSpacing.spacing24,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: GdsSpacing.spacing8,
          children: [
            Text(
              '인기 그림 순위',
              style:
                  context.isMobile
                      ? GdsTypography.title2.copyWith(color: colors.text.grayBold)
                      : GdsTypography.title1.copyWith(color: colors.text.grayBold),
            ),
            Text(
              '인기 그림은 40위까지 노출됩니다',
              style: GdsTypography.label6.copyWith(color: colors.text.graySubtle),
            ),
          ],
        ),
      ),
    );
  }

  static AppBar createAppBar() {
    return AppBar(
      behavior: MaterialAppBarBehavior(),
      body: RankingHeader(),
    );
  }
}
