import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/widget/grimity_post_card.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeLatestPostView extends ConsumerWidget {
  const HomeLatestPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestPost = ref.watch(latestPostDataProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('자유게시판 최신 글', style: AppTypeface.subTitle1),
              Text('더보기', style: AppTypeface.caption1.copyWith(color: AppColor.gray600)),
            ],
          ),
          latestPost.maybeWhen(
            data: (data) => _LatestPostListView(posts: data),
            orElse: () => Skeletonizer(child: _LatestPostListView(posts: Post.emptyList)),
          ),
        ],
      ),
    );
  }
}

class _LatestPostListView extends StatelessWidget {
  const _LatestPostListView({required this.posts});

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      separatorBuilder: (context, index) {
        return Divider(color: AppColor.gray300, height: 1, thickness: 1);
      },
      itemBuilder: (context, index) => GrimityPostCard(post: posts[index]),
    );
  }
}
