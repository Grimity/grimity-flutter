import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/sign_up/widget/sign_up_subtitle.dart';

class SignUpUrlView extends StatelessWidget {
  const SignUpUrlView({
    super.key,
    required this.nickname,
    required this.urlTextField,
  });

  final String nickname;
  final Widget urlTextField;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: context.isMobile ? GdsSpacing.spacing40 : GdsSpacing.spacing48,
        left: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing40,
        right: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing40,
        bottom: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SignUpSubtitle(
            subtitle: '프로필 URL을 정해주세요',
            description: '단 하나뿐인 프로필 주소로 사용돼요',
          ),
          Gap(GdsSpacing.spacing40),
          Text(
            'www.grimity.com/',
            style: GdsTypography.title2.copyWith(color: colors.text.grayBold),
          ),
          Gap(GdsSpacing.spacing12),
          urlTextField,
        ],
      ),
    );
  }
}
