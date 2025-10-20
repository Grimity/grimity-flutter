import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';

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
        this == DrawerMenuItem.following;
  }
}
