import 'package:flutter/material.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/board/tabs/provider/board_post_data_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_pagination_widget.dart';
import 'package:grimity/presentation/common/widget/grimity_post_feed.dart';
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

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GrimityPostFeed(posts: posts, showPostType: type == PostType.all ? true : false, cardHorizontalPadding: 16),
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
