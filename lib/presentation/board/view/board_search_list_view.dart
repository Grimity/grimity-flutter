import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/board/provider/board_search_data_provider.dart';
import 'package:grimity/presentation/board/provider/board_search_query_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_pagination_widget.dart';
import 'package:grimity/presentation/common/widget/grimity_post_feed.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BoardSearchListView extends ConsumerWidget {
  const BoardSearchListView({super.key, required this.posts, required this.totalCount, required this.scrollController});

  final List<Post> posts;
  final int totalCount;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(searchDataProvider.notifier);

    // keyword 타입이 제목+내용일 때 만 사용
    final keyword =
        ref.read(searchQueryProvider).searchType == SearchType.combined ? ref.read(searchQueryProvider).keyword : null;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GrimityPostFeed(posts: posts, cardHorizontalPadding: 16, showPostType: true, keyword: keyword),
        GrimityPaginationWidget(
          currentPage: notifier.currentPage,
          size: notifier.size,
          totalCount: totalCount,
          onPageSelected: (page) {
            if (scrollController.hasClients) {
              scrollController.animateTo(0, duration: Duration(milliseconds: 250), curve: Curves.easeOut);
            }
            notifier.goToPage(page);
          },
        ),
      ],
    );
  }
}
