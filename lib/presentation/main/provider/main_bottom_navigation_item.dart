import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';

enum MainNavigationItem {
  home,
  ranking,
  following,
  board,
  chatMessage;

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
      case MainNavigationItem.chatMessage:
        return Assets.icons.main.message;
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
      case MainNavigationItem.chatMessage:
        return ChatRoute.name;
    }
  }

  // Fab Tap시 화면 전환 처리.
  void onFabTap(BuildContext context) {
    switch (this) {
      case MainNavigationItem.board:
        PostUploadRoute().push(context);
        break;
      case MainNavigationItem.chatMessage:
        NewChatRoute().push(context);
        break;
      default:
        FeedUploadRoute().push(context);
        break;
    }
  }
}
