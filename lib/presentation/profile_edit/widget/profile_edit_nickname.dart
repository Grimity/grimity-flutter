import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/text_field/grimity_text_field.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditNickname extends HookConsumerWidget {
  const ProfileEditNickname({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameController = useTextEditingController(text: ref.watch(profileEditProvider).nickname);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("닉네임", style: AppTypeface.caption1),
        Gap(10),
        GrimityTextField.normal(
          state: ref.read(profileEditProvider).nicknameState,
          controller: nicknameController,
          hintText: "닉네임을 입력해주세요.",
          maxLength: 12,
          onChanged: (value) {
            ref.read(profileEditProvider.notifier).updateNickname(value);
          },
          errorText: ref.read(profileEditProvider).nicknameCheckMessage,
        ),
      ],
    );
  }
}
