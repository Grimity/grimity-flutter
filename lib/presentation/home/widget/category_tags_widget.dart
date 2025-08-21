import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/hook/home_searching_hooks.dart';

class CategoryTagsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = DrawingHooks.useCategories(ref);
    final selectedCategory = DrawingHooks.useSelectedCategory(ref);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '추천태그',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return GestureDetector(
                onTap: () => DrawingHooks.useSelectCategory(ref, category),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green[100] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.green[300]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.green[700] : Colors.grey[700],
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