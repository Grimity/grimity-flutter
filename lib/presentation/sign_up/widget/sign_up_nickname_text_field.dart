import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/common/widget/text_field/grimity_underline_text_field.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpNicknameTextField extends HookConsumerWidget {
  const SignUpNicknameTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();

    return GrimityUnderlineTextField.normal(
      controller: textController,
      state: ref.watch(signUpProvider).nicknameState,
      maxLength: 12,
      hintText: '프로필에 노출될 닉네임을 입력해주세요',
      errorText: ref.watch(signUpProvider).nicknameCheckMessage,
      onChanged: (value) {
        ref.read(signUpProvider.notifier).updateNickname(value);
      },
    );
  }
}
