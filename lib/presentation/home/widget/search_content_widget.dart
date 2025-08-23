import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/hook/home_searching_hooks.dart';
import 'package:grimity/presentation/home/widget/category_tags_widget.dart';
import 'package:grimity/presentation/home/widget/drawing_grid_widget.dart';
import 'package:grimity/presentation/home/widget/search_free_widget.dart';
import 'package:grimity/presentation/home/widget/search_user_widget.dart';
import 'package:grimity/presentation/home/widget/empty_state_widget.dart';

class NoRelatedResult extends StatelessWidget {
  final String keyword;
  const NoRelatedResult({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyStateWidget(
      ),
    );
  }
}

class SearchContentWidget extends ConsumerWidget {
  const SearchContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = DrawingHooks.useSelectedTab(ref);
    final drawings = DrawingHooks.useDrawings(ref);
    final query = DrawingHooks.useSearchQuery(ref)?.trim() ?? '';

    if (query.isEmpty) {
      return CategoryTagsWidget();
    }

    switch (selectedTab) {
      case 0:
        if (drawings.isEmpty) {
          return NoRelatedResult(keyword: query);
        }
        return DrawingsGridWidget();

      case 1:
        return SearchUserWidget();

      case 2:
        return SearchFreeWidget();

      default:
        return NoRelatedResult(keyword: query);
    }
  }
}

// class SearchUserWidgetWrapper extends ConsumerWidget {
//   final String keyword;
//   const SearchUserWidgetWrapper({super.key, required this.keyword});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // 예시: users 검색 결과 훅 (프로젝트 훅 이름에 맞춰 수정)
//     final users = DrawingHooks.useSearchedUsers(ref) ?? const [];

//     if (users.isEmpty) {
//       return NoRelatedResult(keyword: keyword);
//     }
//     return SearchUserWidget();
//   }
// }

// class SearchFreeWidgetWrapper extends ConsumerWidget {
//   final String keyword;
//   const SearchFreeWidgetWrapper({super.key, required this.keyword});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // 예시: 자유게시판 검색 결과 훅 (프로젝트 훅 이름에 맞춰 수정)
//     final posts = DrawingHooks.useSearchedFreePosts(ref) ?? const [];

//     if (posts.isEmpty) {
//       return NoRelatedResult(keyword: keyword);
//     }
//     return SearchFreeWidget();
//   }
// }
