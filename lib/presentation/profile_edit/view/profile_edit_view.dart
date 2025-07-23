import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/presentation/common/widget/grimity_pop_scope.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_app_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_cancel_dialog.dart';

class ProfileEditView extends HookConsumerWidget {
  const ProfileEditView({
    super.key,
    required this.editBackground,
    required this.editProfileImage,
    required this.editNickname,
    required this.editDescription,
    required this.editUrl,
    required this.editLink,
    required this.editSaveButton,
  });

  final Widget editBackground;
  final Widget editProfileImage;
  final Widget editNickname;
  final Widget editDescription;
  final Widget editUrl;
  final Widget editLink;
  final Widget editSaveButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileEditProvider);

    return Scaffold(
      appBar: const ProfileEditAppBar(),
      bottomNavigationBar: editSaveButton,
      body: GrimityPopScope(
        canPop: state.isSaved,
        callback: () {
          if (state.isSaved == false) {
            showCancelEditDialog(context);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              editBackground,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(60),
                        editNickname,
                        Gap(24),
                        editDescription,
                        Gap(24),
                        editUrl,
                        Gap(24),
                        editLink,
                        Gap(34),
                      ],
                    ),
                    editProfileImage,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
