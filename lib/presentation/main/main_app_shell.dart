import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';
import 'package:grimity/presentation/main/widget/main_bottom_navigation_bar.dart';

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
      endDrawer: MainAppDrawer(),
      body: widget.navigationShell,
      bottomNavigationBar: MainBottomNavigationBar(navigationShell: widget.navigationShell),
    );
  }
}
