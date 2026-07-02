import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_feed.dart';

class GrimityPostView extends StatelessWidget {
  const GrimityPostView({
    super.key,
    required this.posts,
    required this.totalCount,
    required this.currentPage,
    required this.size,
    required this.onPageChanged,
    this.noticePosts = const [],
    this.scrollController,
    this.showPostType = false,
    this.showBookMark = false,
    this.showNoticePostType,
    this.isBookMark = false,
    this.keyword,
    this.cardHorizontalPadding = 16,
    this.shrinkWrap = false,
  });

  final List<Post> posts;
  final List<Post> noticePosts;
  final int totalCount;
  final int currentPage;
  final int size;
  final ValueChanged<int> onPageChanged;
  final ScrollController? scrollController;
  final bool showPostType;
  final bool showBookMark;
  final bool? showNoticePostType;
  final bool isBookMark;
  final String? keyword;
  final double cardHorizontalPadding;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final pageCount = (totalCount / size).ceil();
    final currentPageIndex =
        currentPage <= 1
            ? 0
            : currentPage > pageCount
            ? pageCount - 1
            : currentPage - 1;

    return ListView(
      shrinkWrap: shrinkWrap,
      controller: scrollController,
      physics: shrinkWrap ? NeverScrollableScrollPhysics() : null,
      padding: EdgeInsets.zero,
      children: [
        if (noticePosts.isNotEmpty)
          GrimityPostFeed(
            posts: noticePosts,
            showPostType: showNoticePostType ?? showPostType,
            showBookMark: showBookMark,
            cardHorizontalPadding: cardHorizontalPadding,
          ),
        GrimityPostFeed(
          posts: posts,
          showPostType: showPostType,
          showBookMark: showBookMark,
          isBookMark: isBookMark,
          keyword: keyword,
          cardHorizontalPadding: cardHorizontalPadding,
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
                if (scrollController?.hasClients == true) {
                  scrollController!.animateTo(
                    0,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                }

                onPageChanged(page + 1);
              },
            ),
          ),
      ],
    );
  }
}
