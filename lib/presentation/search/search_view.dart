import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:grimity/presentation/search/widget/search_app_bar.dart';
import 'package:grimity/presentation/search/widget/search_tab_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchView extends HookConsumerWidget {
  const SearchView({
    super.key,
    required this.recommendTagView,
    required this.searchFeedTabView,
    required this.searchUserTabView,
    required this.searchPostTabView,
  });

  final Widget recommendTagView;
  final Widget searchFeedTabView;
  final Widget searchUserTabView;
  final Widget searchPostTabView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);
    final tabController = useTabController(initialLength: 3);

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SearchAppBar(),
              SliverPersistentHeader(pinned: true, delegate: SearchTabBar(tabController: tabController)),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children:
                // 검색을 진행하지 않았을때는 각 탭에 추천 태그를 표시.
                keyword.isEmpty
                    ? [recommendTagView, recommendTagView, recommendTagView]
                    : [searchFeedTabView, searchUserTabView, searchPostTabView],
          ),
        ),
      ),
    );
  }
}
