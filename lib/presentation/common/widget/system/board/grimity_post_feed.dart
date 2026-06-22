import 'package:flutter/material.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_card.dart';

class GrimityPostFeed extends StatelessWidget {
  const GrimityPostFeed({
    super.key,
    required this.posts,
    this.cardHorizontalPadding = 0,
    this.showPostType = false,
    this.isBookMark = false,
    this.keyword,
  });

  final List<Post> posts;
  final double cardHorizontalPadding;
  final bool showPostType;
  final bool isBookMark;
  final String? keyword;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...posts.map((post) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: cardHorizontalPadding),
            child: GrimityPostCard(
              post: post,
              showPostType: showPostType,
              isBookMark: isBookMark,
              keyword: keyword,
            ),
          );
        }),
      ],
    );
  }
}
