import 'package:flutter/material.dart' show TabController;
import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/board/provider/board_notice_data_provider.dart';
import 'package:grimity/presentation/board/provider/board_post_data_provider.dart';
import 'package:grimity/presentation/board/provider/board_search_query_provider.dart';
import 'package:grimity/presentation/board/widget/board_search_header.dart';
import 'package:grimity/presentation/board/widget/board_tab_header.dart';
import 'package:grimity/presentation/board/widget/board_title_header.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BoardView extends HookConsumerWidget {
  const BoardView({super.key, required this.tabList});

  final List<PostType> tabList;

  List<AppBar> buildAppBars(
    BuildContext context,
    ValueNotifier<PostType> type,
    TabController tabController,
  ) {
    final colors = context.gdsColors;

    if (context.isMobile) {
      return [
        AppBar(
          behavior: MaterialAppBarBehavior(floating: true),
          body: Padding(
            padding: EdgeInsets.all(GdsSpacing.spacing16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing12,
              children: [
                BoardTitleHeader(),
                BoardSearchHeader(type: type.value),
              ],
            ),
          ),
        ),
        AppBar(
          behavior: AbsoluteAppBarBehavior(),
          body: Padding(
            padding: EdgeInsets.only(
              top: GdsSpacing.spacing4,
              left: GdsSpacing.spacing16,
              right: GdsSpacing.spacing16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing12,
              children: [
                BoardTabHeader(
                  tabController: tabController,
                  types: tabList,
                ),
              ],
            ),
          ),
        ),
      ];
    }

    // 테블릿 버전
    return [
      AppBar(
        behavior: MaterialAppBarBehavior(floating: true),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: GdsSpacing.spacing24,
            horizontal: GdsSpacing.spacing20,
          ),
          child: BoardTitleHeader(),
        ),
      ),
      AppBar(
        behavior: AbsoluteAppBarBehavior(),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: GdsSpacing.spacing20),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.border.graySubtle)),
          ),
          child: Row(
            children: [
              Expanded(
                child: BoardTabHeader(
                  tabController: tabController,
                  types: tabList,
                ),
              ),
              SizedBox(
                width: 320,
                child: BoardSearchHeader(type: type.value),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = useState(tabList.first);
    final tabController = useTabController(initialLength: tabList.length, keys: [tabList.length]);

    useEffect(() {
      void updateType() {
        final newType = tabList[tabController.index];
        if (type.value != newType) {
          type.value = newType;
        }
      }

      tabController.addListener(updateType);
      return () => tabController.removeListener(updateType);
    }, [tabController, tabList]);

    return AppBarConnection(
      appBars: buildAppBars(context, type, tabController),
      child: Builder(
        builder: (context) {
          final postAsync = ref.watch(boardPostDataProvider(type.value));
          final postNotifier = ref.read(boardPostDataProvider(type.value).notifier);
          final isSearching = ref.watch(searchQueryProvider).keyword.trim().length >= 2;
          final noticePosts = ref.watch(boardNoticeDataProvider).value ?? [];

          return postAsync.when(
            data: (posts) {
              return GrimityRefreshIndicator(
                onRefresh: () async {
                  await Future.wait([ref.refresh(boardPostDataProvider(type.value).future)]);
                },
                child: GrimityPostView(
                  posts: posts.posts,
                  noticePosts: !isSearching && postNotifier.currentPage == 1 ? noticePosts : [],
                  totalCount: posts.totalCount ?? 0,
                  currentPage: postNotifier.currentPage,
                  size: postNotifier.size,
                  showPostType: isSearching || type.value == PostType.all,
                  isBookMark: true,
                  onPageChanged: postNotifier.goToPage,
                ),
              );
            },
            loading: () {
              return Skeletonizer(
                child: GrimityPostView(
                  posts: Post.emptyList,
                  noticePosts: !isSearching && postNotifier.currentPage == 1 ? noticePosts : [],
                  totalCount: 0,
                  currentPage: postNotifier.currentPage,
                  size: postNotifier.size,
                  showPostType: isSearching || type.value == PostType.all,
                  isBookMark: true,
                  onPageChanged: postNotifier.goToPage,
                ),
              );
            },
            error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(boardPostDataProvider(type.value))),
          );
        },
      ),
    );
  }
}
