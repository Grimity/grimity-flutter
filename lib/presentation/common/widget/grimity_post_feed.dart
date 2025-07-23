import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/widget/grimity_post_card.dart';

class GrimityPostFeed extends StatelessWidget {
  const GrimityPostFeed({super.key, required this.posts});

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) {
        return Divider(color: AppColor.gray300, height: 1, thickness: 1);
      },
      itemBuilder: (context, index) {
        final post = posts[index];
        return GrimityPostCard(post: post);
      },
    );
  }
}
