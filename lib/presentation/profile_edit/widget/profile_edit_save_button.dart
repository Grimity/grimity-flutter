import 'package:flutter/material.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditSaveButton extends ConsumerWidget {
  const ProfileEditSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: GrimityButton.large(
          text: '변경 내용 저장',
          onTap: () async {
            await ref.read(profileEditProvider.notifier).updateUser();
            if (context.mounted && ref.read(profileEditProvider).isSaved == true) {
              ref.invalidate(profileDataProvider);
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }
}
