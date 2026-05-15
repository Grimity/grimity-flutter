import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';
import 'package:grimity/presentation/profile/profile_view.dart';
import 'package:grimity/presentation/profile/provider/profile_view_type_argument_provider.dart';
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
    final showBlockedToast = useState(false);
    final myUrl = ref.watch(userAuthProvider)?.url ?? '';
    final viewType = url == null || url == myUrl ? ProfileViewType.mine : ProfileViewType.other;
    final profileAsync = ref.watch(profileDataProvider(url ?? myUrl));

    return ProviderScope(
      overrides: [
        profileViewTypeArgumentProvider.overrideWithValue(viewType),
      ],
      child: profileAsync.when(
        data: (user) {
          user ??= User.empty();

          if (user.isBlocked == true && !showBlockedToast.value) {
            showBlockedToast.value = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ToastService.showFailure('차단당한 계정입니다.');
            });
          }

          return ProfileView(
            user: user,
            userProfileView: UserProfileView(user: user),
            feedTabView: ProfileFeedTabView(user: user),
            postTabView: viewType == ProfileViewType.mine ? ProfilePostTabView(user: user) : null,
          );
        },
        loading: () {
          final emptyUser = User.empty();

          return ProfileView(
            user: emptyUser,
            userProfileView: UserProfileView(user: emptyUser),
            feedTabView: ProfileFeedTabView(user: emptyUser),
            postTabView: viewType == ProfileViewType.mine ? ProfilePostTabView(user: emptyUser) : null,
          );
        },
        error:
            (e, s) =>
                SafeArea(child: GrimityStateView.error(onTap: () => ref.invalidate(profileDataProvider(url ?? myUrl)))),
      ),
    );
  }
}
