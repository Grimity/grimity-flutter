import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import '../../../data/model/search/drawing_model.dart';

class DrawingHooks {
  // ======================
  // 기존 훅들
  // ======================

  // 그림 목록 가져오기
  static List<DrawingModel> useDrawings(WidgetRef ref) {
    return ref.watch(filteredDrawingsProvider);
  }

  // 선택된 탭 가져오기
  static int useSelectedTab(WidgetRef ref) {
    return ref.watch(selectedTabProvider);
  }

  // 탭 선택하기
  static void useSelectTab(WidgetRef ref, int index) {
    ref.read(selectedTabProvider.notifier).state = index;
  }

  // 카테고리 목록 가져오기
  static List<String> useCategories(WidgetRef ref) {
    return ref.watch(categoriesProvider);
  }

  // 선택된 카테고리 가져오기
  static String useSelectedCategory(WidgetRef ref) {
    return ref.watch(selectedCategoryProvider);
  }

  // 카테고리 선택하기
  static void useSelectCategory(WidgetRef ref, String category) {
    final currentCategory = ref.read(selectedCategoryProvider);
    ref.read(selectedCategoryProvider.notifier).state =
        currentCategory == category ? '' : category;
  }

  // 좋아요 토글
  static void useToggleLike(WidgetRef ref, String drawingId) {
    ref.read(drawingsProvider.notifier).toggleLike(drawingId);
  }

  // 검색어 설정
  static void useSetSearchQuery(WidgetRef ref, String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  // 검색어 가져오기
  static String useSearchQuery(WidgetRef ref) {
    return ref.watch(searchQueryProvider);
  }

  /// 유저 검색 결과 (빈 배열 보장)
  static List<Map<String, dynamic>> useSearchedUsers(WidgetRef ref) {
    final asyncUsers = ref.watch(searchedUsersProvider);
    return asyncUsers.maybeWhen(
      data: (v) => v,
      orElse: () => const <Map<String, dynamic>>[],
    );
  }

  /// 자유게시판 검색 결과 (빈 배열 보장)
  static List<Map<String, dynamic>> useSearchedFreePosts(WidgetRef ref) {
    final asyncPosts = ref.watch(searchedFreePostsProvider);
    return asyncPosts.maybeWhen(
      data: (v) => v,
      orElse: () => const <Map<String, dynamic>>[],
    );
  }
}
