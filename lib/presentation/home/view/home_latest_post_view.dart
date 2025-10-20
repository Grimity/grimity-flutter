import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_feed.dart';
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
              GestureDetector(
                onTap: () => BoardRoute().go(context),
                child: Text('더보기', style: AppTypeface.caption1.copyWith(color: AppColor.gray600)),
              ),
            ],
          ),
          latestPost.maybeWhen(
            data: (data) => GrimityPostFeed(posts: data),
            orElse: () => Skeletonizer(child: GrimityPostFeed(posts: Post.emptyList)),
          ),
        ],
      ),
    );
  }
}
