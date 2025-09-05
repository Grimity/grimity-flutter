import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/hook/home_searching_hooks.dart';

import '../provider/home_searching_provider.dart';

class CategoryTagsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = DrawingHooks.useCategories(ref);
    final selectedCategory = DrawingHooks.useSelectedCategory(ref);
    final kb = MediaQuery.of(context).viewInsets.bottom; // 키보드 높이

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + kb), // <- 하단에 키보드 높이만큼 여유
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '추천태그',
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  DrawingHooks.useSelectCategory(ref, category);
                  ref.read(searchQueryProvider.notifier).state = category;
                  // ref.read(searchSortProvider.notifier).state = SearchSort.accuracy;
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
