import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_placeholder.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';

class ProfileEditProfileImage extends ConsumerWidget {
  const ProfileEditProfileImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned.fill(
      top: -40,
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => showProfileImageBottomSheet(context, ref),
          child: Stack(
            children: [
              GrimityProfileImage(url: ref.watch(profileEditProvider).image),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  border: Border.all(color: Colors.white, width: 4),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Assets.icons.profileEdit.camera.svg(width: 30, height: 30)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
