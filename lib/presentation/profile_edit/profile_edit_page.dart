import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/profile_edit/view/profile_edit_view.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_background.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_description.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_link.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_nickname.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_profile_image.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_save_button.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_url.dart';

class ProfileEditPage extends ConsumerWidget {
  const ProfileEditPage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfileEditView(
      editBackground: ProfileEditBackground(),
      editProfileImage: ProfileEditProfileImage(),
      editNickname: ProfileEditNickname(),
      editDescription: ProfileEditDescription(),
      editUrl: ProfileEditUrl(),
      editLink: ProfileEditLink(),
      editSaveButton: ProfileEditSaveButton(),
    );
  }
}
