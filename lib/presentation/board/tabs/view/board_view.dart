import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/board/tabs/provider/board_post_data_provider.dart';
import 'package:grimity/presentation/board/tabs/view/board_list_view.dart';
import 'package:grimity/presentation/board/tabs/widget/board_tab_bar.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BoardView extends HookConsumerWidget {
  const BoardView({super.key, required this.boardAppBar, required this.boardSearchBar, required this.tabList});

  final Widget boardAppBar;
  final Widget boardSearchBar;
  final List<PostType> tabList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final tabController = useTabController(initialLength: tabList.length);
    useListenable(tabController);

    final isAllTab = tabList[tabController.index] == PostType.all;

    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          boardAppBar,
          SliverPersistentHeader(pinned: true, delegate: BoardTabBar(tabController: tabController, tabList: tabList)),
          if (isAllTab) SliverToBoxAdapter(child: boardSearchBar),
        ];
      },
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children:
            tabList.map((type) {
              final postAsync = ref.watch(boardPostDataProvider(type));

              return postAsync.when(
                data:
                    (posts) => GrimityRefreshIndicator(
                      onRefresh: () async {
                        await Future.wait([ref.refresh(boardPostDataProvider(type).future)]);
                      },
                      child: BoardListView(
                        posts: posts.posts,
                        totalCount: posts.totalCount ?? 0,
                        type: type,
                        scrollController: scrollController,
                      ),
                    ),
                loading:
                    () => Skeletonizer(
                      child: BoardListView(
                        posts: Post.emptyList,
                        totalCount: 0,
                        type: type,
                        scrollController: scrollController,
                      ),
                    ),
                error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(boardPostDataProvider(type))),
              );
            }).toList(),
      ),
    );
  }
}
