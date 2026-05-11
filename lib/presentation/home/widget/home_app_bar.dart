import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 사용자 아바타 이미지 URL 가져오기
    final avatarImage = ref.watch(
      userAuthProvider.select((user) => user?.image),
    );

    // 알림 여부 가져오기
    final hasNotification = ref.watch(
      userAuthProvider.select((user) => user?.hasNotification ?? false),
    );

    return SliverToBoxAdapter(
      child: SafeArea(
        child: GdsTopNavigation.main(
          onSearch: () => SearchRoute().push(context),
          onAvatar: () => Scaffold.of(context).openEndDrawer(),
          onNotification: () => NotificationRoute().push(context),
          avatarImageUrl: avatarImage,
          hasNotification: hasNotification,
        ),
      ),
    );
  }
}
