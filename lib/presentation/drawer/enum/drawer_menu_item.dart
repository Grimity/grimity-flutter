import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';

enum DrawerMenuItem {
  home("홈"),
  paint("인기 그림"),
  board("자유 게시판"),
  following("팔로잉"),
  chat("DM"),
  storage("내 보관함"),
  setting("설정");

  final String title;

  const DrawerMenuItem(this.title);

  SvgGenImage get icon {
    switch (this) {
      case DrawerMenuItem.home:
        return Assets.icons.drawer.home;
      case DrawerMenuItem.paint:
        return Assets.icons.drawer.paint;
      case DrawerMenuItem.board:
        return Assets.icons.drawer.board;
      case DrawerMenuItem.following:
        return Assets.icons.drawer.following;
      case DrawerMenuItem.chat:
        return Assets.icons.drawer.chat;
      case DrawerMenuItem.storage:
        return Assets.icons.drawer.storage;
      case DrawerMenuItem.setting:
        return Assets.icons.drawer.setting;
    }
  }

  String get path {
    switch (this) {
      case DrawerMenuItem.home:
        return HomeRoute.path;
      case DrawerMenuItem.paint:
        return RankingRoute.path;
      case DrawerMenuItem.board:
        return BoardRoute.path;
      case DrawerMenuItem.following:
        return FollowingRoute.path;
      case DrawerMenuItem.chat:
        return ChatRoute.path;
      case DrawerMenuItem.storage:
        return StorageRoute.path;
      case DrawerMenuItem.setting:
        return SettingRoute.path;
    }
  }

  bool get isGo {
    return this == DrawerMenuItem.home ||
        this == DrawerMenuItem.paint ||
        this == DrawerMenuItem.board ||
        this == DrawerMenuItem.following ||
        this == DrawerMenuItem.chat;
  }

  /// 현재 배지를 표시할 수 있는지에 대한 여부.
  bool shouldVisibleBadge(WidgetRef ref) {
    if (this == DrawerMenuItem.chat) {
      return ref.watch(userAuthProvider)?.hasUnreadChatMessage ?? false;
    }

    return false;
  }

  Widget build(
    BuildContext context,
    WidgetRef ref,
    Widget child,
  ) {
    return shouldVisibleBadge(ref) ? badgeWith(child: child) : child;
  }

  /// 배지를 표시하도록 위젯 트리를 재구성합니다.
  Widget badgeWith({required Widget child}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 3,
      children: [
        child,
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: Offset(0, 3),
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColor.main,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
