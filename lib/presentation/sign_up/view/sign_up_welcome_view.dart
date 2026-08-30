import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';

class SignUpWelcomeView extends ConsumerWidget {
  const SignUpWelcomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GdsIcon.uploadSuccess.build(
            width: 120,
            height: 120,
          ),
          Gap(GdsSpacing.spacing24),
          Text(
            '가입을 축하드려요!',
            style: context.isMobile
                ? GdsTypography.title2.copyWith(color: colors.text.grayBold)
                : GdsTypography.title1.copyWith(color: colors.text.grayBold),
          ),
          Gap(GdsSpacing.spacing12),
          Text(
            '마음껏 그림을 공유하고\n자유롭게 이야기를 나눠보세요',
            textAlign: TextAlign.center,
            style: GdsTypography.body1R.copyWith(color: colors.text.grayBold),
          ),
        ],
      ),
    );
  }
}
