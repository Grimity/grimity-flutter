import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/data/model/search/drawing_model.dart';

class DrawingHooks {

  // ---- Drawings ----
  static List<DrawingModel> useDrawings(WidgetRef ref) {
    return ref.watch(filteredDrawingsProvider);
  }

  // ---- Tabs ----
  static int useSelectedTab(WidgetRef ref) {
    return ref.watch(selectedTabProvider);
  }

  static void useSelectTab(WidgetRef ref, int index) {
    ref.read(selectedTabProvider.notifier).state = index;
  }

  // ---- Categories ----
  static List<String> useCategories(WidgetRef ref) {
    final async = ref.watch(categoriesProvider);
    return async.maybeWhen(
      data: (v) => v,
      orElse: () => const [],
    );
  }


  static String useSelectedCategory(WidgetRef ref) {
    return ref.watch(selectedCategoryProvider);
  }

  static void useSelectCategory(WidgetRef ref, String category) {
    final current = ref.read(selectedCategoryProvider);
    ref.read(selectedCategoryProvider.notifier).state =
        current == category ? '' : category;
  }

  // ---- Likes ----
  static void useToggleLike(WidgetRef ref, String drawingId) {
    ref.read(drawingsProvider.notifier).toggleLike(drawingId);
  }

  // ---- Search ----
  static void useSetSearchQuery(WidgetRef ref, String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  static String useSearchQuery(WidgetRef ref) {
    return ref.watch(searchQueryProvider);
  }

  static List<Map<String, String>> useSearchedUsers(WidgetRef ref) {
    return ref.watch(filteredUsersProvider);
  }
  
  static List<Map<String, String>> useSearchedFreePosts(WidgetRef ref) {
    return ref.watch(filteredFreePostsProvider);
  }
}
