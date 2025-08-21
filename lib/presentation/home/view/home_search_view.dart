import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/widget/search_app_bar.dart';
import 'package:grimity/presentation/home/widget/tab_bar_widget.dart';
import '../widget/empty_state_widget.dart';
import 'package:grimity/presentation/home/widget/drawing_grid_widget.dart';
import 'package:grimity/presentation/home/widget/category_tags_widget.dart';
import 'package:grimity/presentation/home/hook/home_searching_hooks.dart';

class MainView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = DrawingHooks.useSelectedTab(ref);
    final drawings = DrawingHooks.useDrawings(ref);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchAppBar(),
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