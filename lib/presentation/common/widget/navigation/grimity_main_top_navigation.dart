import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';

class GrimityMainTopNavigation extends ConsumerWidget {
  const GrimityMainTopNavigation({
    super.key,
    this.onBack,
    this.onSearch,
    this.onAvatar,
    this.onNotification,
  });

  final VoidCallback? onBack;
  final VoidCallback? onSearch;
  final VoidCallback? onAvatar;
  final VoidCallback? onNotification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarImage = ref.watch(userAuthProvider.select((user) => user?.image));
    final hasNotification = ref.watch(userAuthProvider.select((user) => user?.hasNotification ?? false));

    return GdsTopNavigation.main(
      onSearch: onSearch ?? () => const SearchRoute().push(context),
      onAvatar: onAvatar ?? () => Scaffold.maybeOf(context)?.openEndDrawer(),
      onNotification: onNotification ?? () => const NotificationRoute().push(context),
      avatarImageUrl: avatarImage,
      hasNotification: hasNotification,
    );
  }
}
