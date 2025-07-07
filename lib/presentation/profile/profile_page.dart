import 'package:flutter/material.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/profile/profile_view.dart';
import 'package:grimity/presentation/profile/view/user_profile_view.dart';
import 'package:grimity/presentation/profile/view/profile_feed_tab_view.dart';
import 'package:grimity/presentation/profile/view/profile_post_tab_view.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// [url]이 null 이면 로그인한 유저의 프로필을 보여준다.
/// [url]이 null 이 아니면 [url]에 해당하는 유저의 프로필을 보여준다.
class ProfilePage extends HookConsumerWidget {
  final String? url;

  const ProfilePage({super.key, this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider(url ?? (ref.watch(userAuthProvider)?.url ?? '')));

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
