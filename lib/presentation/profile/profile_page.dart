import 'package:flutter/material.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/profile/profile_view.dart';
import 'package:grimity/presentation/profile/view/user_profile_view.dart';
import 'package:grimity/presentation/profile/view/profile_feed_tab_view.dart';
import 'package:grimity/presentation/profile/view/profile_post_tab_view.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider(ref.read(userAuthProvider)?.url ?? ''));

    return profileAsync.maybeWhen(
      data: (user) {
        user ??= User.empty();

        return ProfileView(
          user: user,
          userProfileView: UserProfileView(user: user),
          feedTabView: ProfileFeedTabView(user: user),
          postTabView: ProfilePostTabView(user: user),
        );
      },
      orElse: () {
        final emptyUser = User.empty();

        return ProfileView(
          user: emptyUser,
          userProfileView: UserProfileView(user: emptyUser),
          feedTabView: ProfileFeedTabView(user: emptyUser),
          postTabView: ProfilePostTabView(user: emptyUser),
        );
      },
    );
  }
}
