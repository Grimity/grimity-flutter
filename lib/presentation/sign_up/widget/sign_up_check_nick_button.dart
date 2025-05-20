import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/presentation/common/widget/grimity_button.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';

class SignUpCheckNickButton extends ConsumerWidget {
  const SignUpCheckNickButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled =
        ref.watch(signUpProvider).nickname.length >= 2 &&
        ref.watch(signUpProvider).isTermsAgreed &&
        ref.watch(signUpProvider).nicknameState != GrimityTextFieldState.error;

    return GrimityButton(
      isEnabled: isEnabled,
      '다음',
      onTap: () async {
        await ref.read(signUpProvider.notifier).checkNicknameDuplicate();
      },
    );
  }
}
