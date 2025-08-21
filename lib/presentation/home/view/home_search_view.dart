import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/tab_bar_widget.dart';
import '../widgets/drawings_grid_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/category_tags_widget.dart';
import '../hooks/drawing_hooks.dart';

class MainView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = DrawingHooks.useSelectedTab(ref);
    final drawings = DrawingHooks.useDrawings(ref);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(),
            TabBarWidget(),
            if (selectedTab == 0 && drawings.isEmpty)
              Expanded(child: EmptyStateWidget())
            else if (selectedTab == 0)
              Expanded(child: DrawingsGridWidget())
            else if (selectedTab == 2)
                Expanded(child: CategoryTagsWidget())
              else
                Expanded(
                  child: Center(
                    child: Text(
                      selectedTab == 1 ? '휴지 탭' : '자유게시판 탭',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}