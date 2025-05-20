import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';

class SignUpUrlView extends StatelessWidget {
  const SignUpUrlView({super.key, required this.nickname, required this.urlTextField, required this.registerButton});

  final String nickname;
  final Widget urlTextField;
  final Widget registerButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_SignUpDescription(nickname: nickname), const Gap(4), urlTextField, const Spacer(), registerButton],
    );
  }
}

class _SignUpDescription extends StatelessWidget {
  const _SignUpDescription({required this.nickname});

  final String nickname;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$nickname님,\n프로필 URL을 설정해주세요', style: AppTypeface.title3),
        Gap(8),
        Text('단 하나뿐인 프로필 주소로 사용되어요', style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
        Gap(24),
        Text('www.grimity.com/', style: AppTypeface.label2.copyWith(color: AppColor.gray600)),
      ],
    );
  }
}
