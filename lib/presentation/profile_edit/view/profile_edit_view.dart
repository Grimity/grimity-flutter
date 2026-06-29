import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/widget/grimity_pop_scope.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_cancel_alert.dart';

class ProfileEditView extends HookConsumerWidget {
  const ProfileEditView({
    super.key,
    required this.editBackground,
    required this.editProfileImage,
    required this.editNickname,
    required this.editDescription,
    required this.editUrl,
    required this.editLink,
    required this.isModal,
  });

  final Widget editBackground;
  final Widget editProfileImage;
  final Widget editNickname;
  final Widget editDescription;
  final Widget editUrl;
  final Widget editLink;
  final bool isModal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileEditProvider);

    return GrimityPopScope(
      canPop: !state.isSaveable,
      callback: () {
        if (state.isSaveable) {
          showCancelEditAlert(context);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            editBackground,
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(GdsSpacing.spacing20 + 30),
                      editNickname,
                      Gap(GdsSpacing.spacing20),
                      editDescription,
                      Gap(GdsSpacing.spacing20),
                      editUrl,
                      Gap(GdsSpacing.spacing20),
                      editLink,
                      Gap(GdsSpacing.spacing20),
                    ],
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: editProfileImage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
