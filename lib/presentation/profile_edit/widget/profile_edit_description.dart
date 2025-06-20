import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/grimity_text_field.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditDescription extends HookConsumerWidget {
  const ProfileEditDescription({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descriptionController = useTextEditingController(text: ref.watch(profileEditProvider).description);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("소개글", style: AppTypeface.caption1),
        Gap(10),
        GrimityTextField.normal(
          controller: descriptionController,
          hintText: "소개 문구를 입력하세요",
          maxLength: 100,
          maxLines: 4,
          onChanged: (value) {
            ref.read(profileEditProvider.notifier).updateDescription(value);
          },
        ),
      ],
    );
  }
}
