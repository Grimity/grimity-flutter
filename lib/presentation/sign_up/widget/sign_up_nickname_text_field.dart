import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpNicknameTextField extends HookConsumerWidget {
  const SignUpNicknameTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final state = ref.watch(signUpProvider);
    final errorMessage = state.nicknameCheckMessage;
    final nicknameStatus = state.nicknameState;

    return GdsInput.custom(
      helperText: nicknameStatus == GrimityTextFieldState.error ? errorMessage : null,
      error: true,
      child: GdsTextField.count(
        placeholder: '닉네임을 입력해주세요',
        controller: textController,
        maxLength: 12,
        error: nicknameStatus == GrimityTextFieldState.error,
        success: nicknameStatus == GrimityTextFieldState.success,
        onChanged: ref.read(signUpProvider.notifier).updateNickname,
        onEditingComplete: ref.read(signUpProvider.notifier).checkNicknameDuplicate,
      ),
    );
  }
}
