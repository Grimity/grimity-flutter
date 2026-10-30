import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/search/views/search_feeds.dart';
import 'package:grimity/presentation/search/views/search_posts.dart';
import 'package:grimity/presentation/search/views/search_users.dart';
import 'package:grimity/presentation/search/widgets/search_app_bar.dart';
import 'package:grimity/presentation/search/widgets/search_popular_tags.dart';
import 'package:grimity/presentation/search/widgets/search_tab_bar.dart';
import 'package:pervice/pervice.dart';

/// 그림, 작가, 게시글을 검색하고 탭별로 표시하는 페이지.
class SearchPage extends StatelessWidget {
  const new({
    super.key,
    this.initialKeyword = '',
  });

  final String initialKeyword;

  /// 검색 결과를 구분하는 탭 목록.
  static const views = <GdsTabView>[
    SearchFeeds(),
    SearchUsers(),
    SearchPosts(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.useTabController(
      length: views.length,
    );

    final keyword = context.sharedStateOf(
      () => initialKeyword,
      key: const ValueKey('search-keyword'),
    );

    final sort = context.sharedStateOf(
      () => FeedSearchSort.latest,
      key: const ValueKey('search-sort'),
    );

    // 검색어 2자 이상의 제출 가능한 상태인지 여부.
    final canSubmit = keyword.value.length >= 2;

    return GdsScaffold(
      appBar: SearchAppBar(keyword: keyword),
      body: GdsTransition.crossFade(
        value: canSubmit,
        child: AppBarConnection(
          appBars: [
            // 인기 태그 표시
            if (context.isTablet || !canSubmit) ...[
              AppBar(
                behavior: MaterialAppBarBehavior(),
                body: const SearchPopularTags(),
              ),
            ],

            // 탭 바 표시
            if (context.isTablet || canSubmit) ...[
              AppBar(
                behavior: AbsoluteAppBarBehavior(),
                body: SearchTabBar(
                  controller: controller,
                  keyword: keyword,
                  sort: sort,
                ),
              ),
            ],
          ],
          child: Align(
            alignment: .topCenter,
            child: Builder(
              builder: (context) {
                // 사용자가 검색어를 입력하지 않은 경우.
                if (!canSubmit) {
                  return GdsEmptyState(
                    illust: .illust,
                    title: '그리미티에서 찾아보세요!',
                  );
                }

                // 탭 화면 표시
                return TabBarView(
                  controller: controller,
                  children: views.keepAliveWrappers,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
