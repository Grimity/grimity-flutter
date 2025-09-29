import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/search/hook/search_hooks.dart';

class TabBarWidget extends ConsumerWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = DrawingHooks.useSelectedTab(ref);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTabItem(ref, '그림', 0, selectedTab == 0),
          SizedBox(width: 24),
          _buildTabItem(ref, '유저', 1, selectedTab == 1),
          SizedBox(width: 24),
          _buildTabItem(ref, '자유게시판', 2, selectedTab == 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(WidgetRef ref, String title, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => DrawingHooks.useSelectTab(ref, index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}