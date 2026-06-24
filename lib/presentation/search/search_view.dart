import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_drawer.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:grimity/presentation/search/view/search_welcome_state.dart';
import 'package:grimity/presentation/search/widget/search_app_bar.dart';
import 'package:grimity/presentation/search/widget/search_recommand_tag_bar.dart';
import 'package:grimity/presentation/search/widget/search_tab_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchView extends HookConsumerWidget {
  const SearchView({
    super.key,
    this.initialKeyword,
    required this.searchFeedTabView,
    required this.searchUserTabView,
    required this.searchPostTabView,
  });

  final String? initialKeyword;
  final Widget searchFeedTabView;
  final Widget searchUserTabView;
  final Widget searchPostTabView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);
    final tabController = useTabController(initialLength: 3);

    // 초기 키워드가 있는 경우 searchKeyword update
    useEffect(() {
      if (initialKeyword != null && initialKeyword!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(searchKeywordProvider.notifier).setKeyword(initialKeyword!);
        });
      }
      return null;
    }, [initialKeyword]);

    return GdsScaffold(
      drawer: GrimityDrawer(),
      appBar: SearchAppBar(),
      body: AppBarConnection(
        appBars: buildAppBars(context, ref, tabController),
        child: Builder(
          builder: (context) {
            // 검색을 진행하지 않았을때는 별도의 상태 표시
            if (keyword.isEmpty) {
              return SearchWelcomeState();
            }

            return TabBarView(
              controller: tabController,
              children: [
                searchFeedTabView,
                searchUserTabView,
                searchPostTabView,
              ],
            );
          },
        ),
      ),
    );
  }

  List<AppBar> buildAppBars(
    BuildContext context,
    WidgetRef ref,
    TabController controller,
  ) {
    final keyword = ref.watch(searchKeywordProvider);
    final welcome = keyword.isEmpty;

    if (context.isMobile) {
      return [
        AppBar(
          behavior: AbsoluteAppBarBehavior(),
          body: Padding(
            padding: EdgeInsets.only(top: GdsSpacing.spacing16),
            child: welcome ? SearchRecommendTagBar() : SearchTabBar(controller: controller),
          ),
        ),
      ];
    }

    // Tablet
    return [
      AppBar(
        behavior: MaterialAppBarBehavior(floating: true),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: GdsSpacing.spacing16),
          child: SearchRecommendTagBar(),
        ),
      ),
      AppBar(
        behavior: AbsoluteAppBarBehavior(),
        body: Padding(
          padding: EdgeInsets.only(top: GdsSpacing.spacing16),
          child: SearchRecommendTagBar(),
        ),
      ),
    ];
  }
}
