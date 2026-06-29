import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditUrl extends HookConsumerWidget {
  const ProfileEditUrl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: ref.watch(profileEditProvider).url);
    final errorText = ref.read(profileEditProvider).urlCheckMessage;
    final isError = errorText?.isNotEmpty ?? false;

    return GdsInput.custom(
      titleText: '그리미티 URL',
      helperText: errorText,
      error: isError,
      child: GdsTextField(
        controller: controller,
        prefixText: 'www.grimity.com/',
        onChanged: ref.read(profileEditProvider.notifier).updateUrl,
        error: isError,
      ),
    );
  }
}
