import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/presentation/sign_in/provider/sign_in_provider.dart';
import 'package:grimity/presentation/sign_in/widget/sso_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInBodyView extends ConsumerWidget {
  const SignInBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;

    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '그림이',
                style:
                    context.isMobile
                        ? GdsTypography.title2.copyWith(color: colors.text.white)
                        : GdsTypography.title1.copyWith(color: colors.text.white),
              ),
              Gap(GdsSpacing.spacing4),
              Text(
                '시작이 되는 커뮤니티',
                style:
                    context.isMobile
                        ? GdsTypography.title2.copyWith(color: colors.text.white)
                        : GdsTypography.title1.copyWith(color: colors.text.white),
              ),
              Gap(GdsSpacing.spacing8),
              Text(
                '좋아하고 연결되는 곳',
                style: GdsTypography.body1R.copyWith(color: colors.text.white),
              ),
              Gap(GdsSpacing.spacing40),
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: GdsSpacing.spacing12,
                children: [
                  SSOButton(
                    icon: GdsIcon.kakaotalkSimple,
                    name: '카카오',
                    iconColor: colors.surface.inverse,
                    onTap: () {
                      ref.read(signInProvider.notifier).login(ref, LoginProvider.kakao);
                    },
                  ),
                  SSOButton(
                    icon: GdsIcon.google,
                    name: '구글',
                    onTap: () {
                      ref.read(signInProvider.notifier).login(ref, LoginProvider.google);
                    },
                  ),
                  if (Platform.isIOS) ...[
                    SSOButton(
                      icon: GdsIcon.apple,
                      name: '애플',
                      iconColor: colors.surface.inverse,
                      onTap: () {
                        ref.read(signInProvider.notifier).login(ref, LoginProvider.apple);
                      },
                    ),
                  ],
                ],
              ),
              Gap(GdsSpacing.spacing40),
            ],
          ),
        ),
      ),
    );
  }
}
