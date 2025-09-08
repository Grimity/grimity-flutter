import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/widget/grimity_post_feed.dart';
import 'package:grimity/presentation/post_detail/provider/post_latest_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostLatestView extends ConsumerWidget {
  const PostLatestView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestPost = ref.watch(postLatestDataProvider);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('자유게시판 최신글', style: AppTypeface.subTitle1)],
            ),
          ),
          latestPost.maybeWhen(
            data: (data) => GrimityPostFeed(posts: data, showPostType: true, cardHorizontalPadding: 16),
            orElse: () => Skeletonizer(child: GrimityPostFeed(posts: Post.emptyList)),
          ),
        ],
      ),
    );
  }
}
