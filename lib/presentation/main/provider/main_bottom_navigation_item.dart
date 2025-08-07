import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';

enum MainNavigationItem {
  home,
  ranking,
  following,
  board,
  my;

  const MainNavigationItem();

  SvgGenImage get icon {
    switch (this) {
      case MainNavigationItem.home:
        return Assets.icons.main.home;
      case MainNavigationItem.ranking:
        return Assets.icons.main.paint;
      case MainNavigationItem.following:
        return Assets.icons.main.following;
      case MainNavigationItem.board:
        return Assets.icons.main.board;
      case MainNavigationItem.my:
        return Assets.icons.main.defaultProfile;
    }
  }

  String get routeName {
    switch (this) {
      case MainNavigationItem.home:
        return HomeRoute.name;
      case MainNavigationItem.ranking:
        return RankingRoute.name;
      case MainNavigationItem.following:
        return FollowRoute.name;
      case MainNavigationItem.board:
        return BoardRoute.name;
      case MainNavigationItem.my:
        return MyRoute.name;
    }
  }
}