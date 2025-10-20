import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/board/search/provider/board_search_data_provider.dart';
import 'package:grimity/presentation/board/search/view/board_search_list_view.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BoardSearchView extends HookConsumerWidget {
  const BoardSearchView({super.key, required this.boardSearchAppBar, required this.boardSearchBar});

  final Widget boardSearchAppBar;
  final Widget boardSearchBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final searchPostsAsync = ref.watch(searchDataProvider);

    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [boardSearchAppBar, SliverToBoxAdapter(child: boardSearchBar)];
      },
      body: searchPostsAsync.maybeWhen(
        data: (posts) {
          if (posts.posts.isEmpty) {
            return GrimityStateView.resultNull(title: '검색 결과가 없어요', subTitle: '다른 검색어를 입력해보세요');
          }

          return BoardSearchListView(
            posts: posts.posts,
            totalCount: posts.totalCount ?? 0,
            scrollController: scrollController,
          );
        },
        orElse:
            () => Skeletonizer(
              child: BoardSearchListView(posts: Post.emptyList, totalCount: 0, scrollController: scrollController),
            ),
      ),
    );
  }
}
