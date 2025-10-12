import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';

class SignUpCheckNickButton extends ConsumerWidget {
  const SignUpCheckNickButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled =
        ref.watch(signUpProvider).nickname.length >= 2 &&
        ref.watch(signUpProvider).isTermsAgreed &&
        ref.watch(signUpProvider).nicknameState != GrimityTextFieldState.error;

    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: GrimityButton.large(
        text: '다음',
        onTap: () async {
          await ref.read(signUpProvider.notifier).checkNicknameDuplicate();
        },
        status: isEnabled ? ButtonStatus.on : ButtonStatus.off,
      ),
    );
  }
}
