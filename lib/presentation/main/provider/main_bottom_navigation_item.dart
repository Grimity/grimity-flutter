import 'package:grimity/gen/assets.gen.dart';

enum MainNavigationItem {
  home,
  paint,
  following,
  board,
  my;

  const MainNavigationItem();

  SvgGenImage get icon {
    switch (this) {
      case MainNavigationItem.home:
        return Assets.icons.main.home;
      case MainNavigationItem.paint:
        return Assets.icons.main.paint;
      case MainNavigationItem.following:
        return Assets.icons.main.following;
      case MainNavigationItem.board:
        return Assets.icons.main.board;
      case MainNavigationItem.my:
        return Assets.icons.main.defaultProfile;
    }
  }
}