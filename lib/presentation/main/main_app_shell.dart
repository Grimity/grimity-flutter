import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/common/widget/grimity_pop_scope.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_drawer.dart';
import 'package:grimity/presentation/main/provider/main_bottom_navigation_item.dart';
import 'package:grimity/presentation/main/widget/main_bottom_navigation_bar.dart';
import 'package:grimity/presentation/main/widget/main_floating_action_button.dart';

class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;
    final currentIndex = widget.navigationShell.currentIndex;
    final currentItem = MainNavigationItem.values[currentIndex];
    final canPop = currentIndex == MainNavigationItem.home.index;
    final showFab = GoRouter.of(context).state.name == currentItem.routeName && currentItem.showFab;

    return GrimityPopScope(
      canPop: canPop,
      callback: () => widget.navigationShell.goBranch(MainNavigationItem.home.index),
      child: Scaffold(
        backgroundColor: colors.bg.primary,
        endDrawer: GrimityDrawer(),
        body: widget.navigationShell,
        bottomNavigationBar: MainBottomNavigationBar(navigationShell: widget.navigationShell),
        floatingActionButton: showFab ? MainFloatingActionButton(currentIndex: currentIndex) : null,
      ),
    );
  }
}
