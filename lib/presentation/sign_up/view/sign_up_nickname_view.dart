import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';

class SignUpNicknameView extends ConsumerWidget {
  const SignUpNicknameView({
    super.key,
    required this.nicknameTextField,
    required this.termAgreeWidget,
    required this.checkNicknameButton,
  });

  final Widget nicknameTextField;
  final Widget termAgreeWidget;
  final Widget checkNicknameButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SignUpDescription(),
        const Gap(24),
        nicknameTextField,
        const Gap(15),
        termAgreeWidget,
        const Spacer(),
        checkNicknameButton,
      ],
    );
  }
}

class _SignUpDescription extends StatelessWidget {
  const _SignUpDescription();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('활동명을 정해주세요', style: AppTypeface.title3),
        Gap(8),
        Text('가입 후 활동명 변경이 가능해요', style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
      ],
    );
  }
}
