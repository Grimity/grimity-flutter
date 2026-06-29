import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditNickname extends HookConsumerWidget {
  const ProfileEditNickname({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: ref.watch(profileEditProvider).nickname);
    final state = ref.read(profileEditProvider);
    final errorText = state.nicknameCheckMessage;
    final isError = state.nicknameCheckMessage?.isNotEmpty ?? false;

    return GdsInput.custom(
      titleText: '닉네임',
      helperText: errorText,
      error: isError,
      child: GdsTextField.count(
        placeholder: "닉네임을 입력해주세요",
        controller: controller,
        maxLength: 12,
        onChanged: ref.read(profileEditProvider.notifier).updateNickname,
        error: isError,
      ),
    );
  }
}
