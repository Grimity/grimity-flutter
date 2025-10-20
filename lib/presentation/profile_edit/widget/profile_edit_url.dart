import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/text_field/grimity_text_field.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditUrl extends HookConsumerWidget {
  const ProfileEditUrl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grimityUrlController = useTextEditingController(text: ref.watch(profileEditProvider).url);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("링크", style: AppTypeface.caption1),
        Gap(10),
        GrimityTextField.normal(
          state: ref.read(profileEditProvider).urlState,
          controller: grimityUrlController,
          hintText: ref.read(profileEditProvider).url,
          maxLength: 20,
          defaultText: "www.grimity.com/",
          onChanged: (value) {
            ref.read(profileEditProvider.notifier).updateUrl(value);
          },
          errorText: ref.read(profileEditProvider).urlCheckMessage,
        ),
      ],
    );
  }
}
