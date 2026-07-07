import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_title_top_navigation.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';
import 'package:grimity/presentation/profile/provider/profile_view_type_argument_provider.dart';

class ProfileAppBar extends ConsumerWidget {
  const ProfileAppBar({
    super.key,
    required this.userName,
    required this.showUserName,
  });

  final String userName;
  final bool showUserName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = ref.watch(profileViewTypeArgumentProvider);

    if (viewType == ProfileViewType.mine) {
      return GdsTopNavigation.iconButton(
        title: userName,
        onBack: context.pop,
        showTitle: showUserName,
        onIconTap: [
          () => const SearchRoute().push(context),
          () => const StorageRoute().push(context),
          () => const SettingRoute().push(context),
        ],
        icons: [
          GdsIcon.magnifierOutline,
          GdsIcon.inbox,
          GdsIcon.settings,
        ],
      );
    }

    return GrimityTitleTopNavigation(title: showUserName ? userName : null);
  }
}
