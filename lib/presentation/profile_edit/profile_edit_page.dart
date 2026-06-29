import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/profile_edit/view/profile_edit_view.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_app_bar.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_background.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_description.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_link.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_nickname.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_profile_image.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_url.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_save_button.dart';

class ProfileEditPage extends ConsumerWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GdsScaffold(
      appBar: const ProfileEditAppBar(),
      body: _createProfileEditView(false),
    );
  }

  static Widget _createProfileEditView(bool isModal) {
    return ProfileEditView(
      editBackground: ProfileEditBackground(),
      editProfileImage: ProfileEditProfileImage(),
      editNickname: ProfileEditNickname(),
      editDescription: ProfileEditDescription(),
      editUrl: ProfileEditUrl(),
      editLink: ProfileEditLink(),
      isModal: isModal,
    );
  }

  static Future<void> push(BuildContext context) async {
    if (context.isMobile) {
      return const ProfileEditRoute().push(context);
    } else {
      final modal = GdsModal(
        title: '프로필 수정',
        body: _createProfileEditView(true),
        padding: EdgeInsets.zero,
        primaryButton: ProfileSaveButton(),
      );

      return modal.open(context);
    }
  }
}
