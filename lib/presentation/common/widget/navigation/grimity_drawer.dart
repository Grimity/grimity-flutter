import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/follow/follow_page.dart';
import 'package:url_launcher/url_launcher.dart';

class GrimityDrawer extends ConsumerWidget {
  const GrimityDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final user = ref.watch(userAuthProvider);

    return GdsSidebarNavigation(
      size: context.isMobile ? GdsSidebarNavigationSize.md : GdsSidebarNavigationSize.lg,
      padding: EdgeInsets.only(top: statusBarHeight),
      userImageUrl: user?.image,
      userName: user?.name ?? '',
      userId: user?.handle ?? '',
      followerCount: user?.followerCount ?? 0,
      followingCount: user?.followingCount ?? 0,
      onAvatarTap: () => _pushProfile(context, user?.url),
      onHandleTap: () => _pushProfile(context, user?.url),
      onNickNameTap: () => _pushProfile(context, user?.url),
      onFollowerTap: () => FollowPage.pushReplace(context, 1),
      onFollowingTap: () => FollowPage.pushReplace(context, 0),
      onTermsOfServiceTap: () => launchUrl(Uri.parse(AppConst.serviceTermsUrl)),
      onPrivacyPolicyTap: () => launchUrl(Uri.parse(AppConst.privacyPolicyUrl)),
      onBusinessInfoTap: () => const BusinessInfoRoute().push(context),
      onSignOutTap: () => _signOut(context, ref),
      menuItems: [
        GdsSidebarNavigationItem(
          icon: GdsIcon.home,
          label: '홈',
          onTap: () => _go(context, HomeRoute.path),
        ),
        GdsSidebarNavigationItem(
          icon: GdsIcon.paint,
          label: '인기 그림',
          onTap: () => _go(context, RankingRoute.path),
        ),
        GdsSidebarNavigationItem(
          icon: GdsIcon.board,
          label: '자유게시판',
          onTap: () => _go(context, BoardRoute.path),
        ),
        GdsSidebarNavigationItem(
          icon: GdsIcon.following,
          label: '팔로잉',
          onTap: () => _go(context, FollowingRoute.path),
        ),
        GdsSidebarNavigationItem(
          icon: GdsIcon.message,
          label: 'DM',
          onTap: () => _go(context, ChatRoute.path),
          dotPushBadge: user?.hasUnreadChatMessage ?? false,
        ),
        GdsSidebarNavigationItem(
          icon: GdsIcon.inbox,
          label: '보관함',
          onTap: () => _push(context, StorageRoute.path),
        ),
        GdsSidebarNavigationItem(
          icon: GdsIcon.settings,
          label: '설정',
          onTap: () => _push(context, SettingRoute.path),
        ),
      ],
    );
  }

  void _go(BuildContext context, String path) {
    context.pop();
    context.go(path);
  }

  void _push(BuildContext context, String path) {
    context.pop();
    context.push(path);
  }

  void _pushProfile(BuildContext context, String? url) {
    if (url == null) return;
    ProfileRoute(url: url).push(context);
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    return ref.read(userAuthProvider.notifier).performSignOut(context);
  }
}
