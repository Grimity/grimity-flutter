import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_cancel_alert.dart';

class ProfileEditAppBar extends ConsumerWidget {
  const ProfileEditAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(profileEditProvider.notifier);
    final state = ref.watch(profileEditProvider);

    return GdsTopNavigation.editor(
      title: '프로필 수정',
      label: '저장',
      onBack: () => state.isSaveable ? showCancelEditAlert(context) : context.pop(),
      onSave: () => notifier.handleSave(context),
      saveEnabled: state.isSaveable,
    );
  }
}
