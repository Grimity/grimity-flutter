import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/widget/grimity_pop_scope.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';
import 'package:grimity/presentation/main/widget/main_bottom_navigation_bar.dart';
import 'package:grimity/presentation/main/widget/main_floating_action_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// GdsBottomNavigation.main() 아이템 순서와 동일
const _tabRouteNames = [
  HomeRoute.name,
  RankingRoute.name,
  FollowRoute.name,
  BoardRoute.name,
  ChatRoute.name,
];

class MainAppShell extends ConsumerStatefulWidget {
  const MainAppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends ConsumerState<MainAppShell> {
  static const _homeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;
    final currentIndex = widget.navigationShell.currentIndex;
    final canPop = currentIndex == _homeIndex;
    final showFab = GoRouter.of(context).state.name == _tabRouteNames[currentIndex];

    return GrimityPopScope(
      canPop: canPop,
      callback: () => widget.navigationShell.goBranch(_homeIndex),
      child: Scaffold(
        backgroundColor: colors.bg.primary,
        endDrawer: MainAppDrawer(),
        body: widget.navigationShell,
        bottomNavigationBar: MainBottomNavigationBar(navigationShell: widget.navigationShell),
        floatingActionButton: showFab ? MainFloatingActionButton(currentIndex: currentIndex) : null,
      ),
    );
  }
}
