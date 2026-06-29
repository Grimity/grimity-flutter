import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditDescription extends HookConsumerWidget {
  const ProfileEditDescription({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: ref.watch(profileEditProvider).description);

    return GdsInput.custom(
      titleText: '자기소개',
      child: GdsTextArea(
        controller: controller,
        placeholder: '자유롭게 소개를 작성해보세요',
        maxLength: 500,
        onChanged: ref.read(profileEditProvider.notifier).updateDescription,
      ),
    );
  }
}
