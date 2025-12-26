import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';

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
        return Assets.icons.icon.home;
      case MainNavigationItem.ranking:
        return Assets.icons.icon.paint;
      case MainNavigationItem.following:
        return Assets.icons.icon.following;
      case MainNavigationItem.board:
        return Assets.icons.icon.board;
      case MainNavigationItem.chatMessage:
        return Assets.icons.icon.message;
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

  /// 현재 배지를 표시할 수 있는지에 대한 여부.
  bool shouldVisibleBadge(WidgetRef ref) {
    if (this == MainNavigationItem.chatMessage) {
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
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: Offset(0, 5),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColor.accentRed,
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
