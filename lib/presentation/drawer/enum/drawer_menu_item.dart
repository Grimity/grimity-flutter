import 'package:grimity/gen/assets.gen.dart';

enum DrawerMenuItem {
  home("홈"),
  paint("인기 그림"),
  board("자유 게시판"),
  following("팔로잉"),
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
      case DrawerMenuItem.storage:
        return Assets.icons.drawer.storage;
      case DrawerMenuItem.setting:
        return Assets.icons.drawer.setting;
    }
  }
}
