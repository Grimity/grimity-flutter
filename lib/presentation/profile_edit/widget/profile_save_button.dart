import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';

class ProfileSaveButton extends ConsumerWidget {
  const ProfileSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(profileEditProvider.notifier);
    final state = ref.watch(profileEditProvider);

    return GdsSolidButton(
      size: GdsSolidButtonSize.large,
      text: '저장',
      expanded: true,
      enabled: state.isSaveable,
      onPressed: () => notifier.handleSave(context),
    );
  }
}
