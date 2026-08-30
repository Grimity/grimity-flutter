import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/main/provider/main_bottom_navigation_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainBottomNavigationBar extends ConsumerWidget {
  const MainBottomNavigationBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;
    final currentIndex = navigationShell.currentIndex;
    final chatItem = MainNavigationItem.chatMessage;
    final dotIndex = chatItem.shouldVisibleBadge(ref) ? chatItem.index : null;

    return SafeArea(
      top: false,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: colors.bg.primary.withValues(alpha: .9),
          border: Border(top: BorderSide(color: colors.border.graySubtle.withValues(alpha: .9))),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              color: colors.bg.black.withValues(alpha: .04),
              blurRadius: 6,
            ),
          ],
        ),
        child: GdsBottomNavigation.main(
          index: currentIndex,
          dotIndex: dotIndex,
          onPressed: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == currentIndex,
          ),
        ),
      ),
    );
  }
}
