import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/board/search/provider/board_search_data_provider.dart';
import 'package:grimity/presentation/board/common/provider/board_search_query_provider.dart';
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '검색결과 ', style: AppTypeface.label2.copyWith(color: AppColor.gray600)),
                TextSpan(text: totalCount.toString(), style: AppTypeface.label2.copyWith(color: AppColor.gray800)),
                TextSpan(text: '건', style: AppTypeface.label2.copyWith(color: AppColor.gray600)),
              ],
            ),
          ),
        ),
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
