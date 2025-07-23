import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';
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
    return Scaffold(
      endDrawer: MainAppDrawer(currentIndex:widget.navigationShell.currentIndex),
      body: widget.navigationShell,
      bottomNavigationBar: MainBottomNavigationBar(navigationShell: widget.navigationShell),
      floatingActionButton: MainFloatingActionButton(currentIndex: widget.navigationShell.currentIndex),
    );
  }
}
