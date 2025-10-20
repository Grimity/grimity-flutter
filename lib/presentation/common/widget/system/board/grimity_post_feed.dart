import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_card.dart';

class GrimityPostFeed extends StatelessWidget {
  const GrimityPostFeed({
    super.key,
    required this.posts,
    this.cardHorizontalPadding = 0,
    this.showPostType = false,
    this.keyword,
  });

  final List<Post> posts;
  final double cardHorizontalPadding;
  final bool showPostType;
  final String? keyword;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => Divider(color: AppColor.gray300, height: 1, thickness: 1),
      itemBuilder: (context, index) {
        final post = posts[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: cardHorizontalPadding),
          child: GrimityPostCard(post: post, showPostType: showPostType, keyword: keyword),
        );
      },
    );
  }
}
