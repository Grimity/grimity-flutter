import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/presentation/common/widget/grimity_button.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditSaveButton extends ConsumerWidget {
  const ProfileEditSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 54.w,
        child: GrimityButton(
          '변경 내용 저장',
          onTap: () async {
            await ref.read(profileEditProvider.notifier).updateUser();
          },
          hasBottomPadding: false,
        ),
      ),
    );
  }
}
