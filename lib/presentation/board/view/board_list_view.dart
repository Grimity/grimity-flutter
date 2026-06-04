import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/board/provider/board_notice_data_provider.dart';
import 'package:grimity/presentation/board/provider/board_post_data_provider.dart';
import 'package:grimity/presentation/board/provider/board_search_query_provider.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_feed.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BoardListView extends ConsumerWidget {
  const BoardListView({
    super.key,
    required this.posts,
    required this.totalCount,
    required this.type,
    required this.scrollController,
  });

  final List<Post> posts;
  final int totalCount;
  final PostType type;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(boardPostDataProvider(type).notifier);
    final isSearching = ref.watch(searchQueryProvider).keyword.trim().length >= 2;
    final noticePosts = ref.watch(boardNoticeDataProvider).valueOrNull;
    final pageCount = (totalCount / notifier.size).ceil();
    final currentPageIndex =
        notifier.currentPage <= 1
            ? 0
            : notifier.currentPage > pageCount
            ? pageCount - 1
            : notifier.currentPage - 1;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GrimityPostFeed(
          posts: [
            // 1페이지에서만 공지 표시
            if (!isSearching && notifier.currentPage == 1 && noticePosts != null && noticePosts.isNotEmpty)
              ...noticePosts,
            ...posts,
          ],
          showPostType: isSearching || type == PostType.all ? true : false,
          cardHorizontalPadding: 16,
        ),

        if (pageCount > 0)
          Container(
            padding: EdgeInsets.only(
              top: context.isMobile ? GdsSpacing.spacing20 : GdsSpacing.spacing24,
              bottom: GdsSpacing.spacing40,
            ),
            alignment: Alignment.center,
            child: GdsNavigation(
              index: currentPageIndex,
              maxCount: context.isMobile ? 5 : 10,
              pageCount: pageCount,
              onPageChanged: (page) {
                if (scrollController.hasClients) {
                  scrollController.animateTo(0, duration: Duration(milliseconds: 250), curve: Curves.easeOut);
                }

                notifier.goToPage(page + 1);
              },
            ),
          ),
      ],
    );
  }
}
