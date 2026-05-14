import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';

enum MainNavigationItem {
  home,
  ranking,
  following,
  board,
  chatMessage;

  const MainNavigationItem();

  GdsIcon get gdsIcon {
    switch (this) {
      case MainNavigationItem.home:
        return GdsIcon.home;
      case MainNavigationItem.ranking:
        return GdsIcon.paint;
      case MainNavigationItem.following:
        return GdsIcon.following;
      case MainNavigationItem.board:
        return GdsIcon.board;
      case MainNavigationItem.chatMessage:
        return GdsIcon.message;
    }
  }

  String get label {
    switch (this) {
      case MainNavigationItem.home:
        return '홈';
      case MainNavigationItem.ranking:
        return '랭킹';
      case MainNavigationItem.following:
        return '팔로잉';
      case MainNavigationItem.board:
        return '자유게시판';
      case MainNavigationItem.chatMessage:
        return 'DM';
    }
  }

  String get routeName {
    switch (this) {
      case MainNavigationItem.home:
        return HomeRoute.name;
      case MainNavigationItem.ranking:
        return RankingRoute.name;
      case MainNavigationItem.following:
        return FollowingRoute.name;
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

  /// 현재 배지를 표시할 수 있는지에 대한 여부.
  bool shouldVisibleBadge(WidgetRef ref) {
    if (this == MainNavigationItem.chatMessage) {
      return ref.watch(userAuthProvider)?.hasUnreadChatMessage ?? false;
    }

    return false;
  }
}
