import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_feed.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:grimity/presentation/home/widget/home_section_header.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeLatestPostView extends ConsumerWidget {
  const HomeLatestPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestPost = ref.watch(latestPostDataProvider);

    return Column(
      children: [
        HomeSectionHeader(
          title: '자유게시판 최신 글',
          onMoreTap: () => BoardRoute().go(context),
        ),
        const SizedBox(height: GdsSpacing.spacing8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: GdsSpacing.spacing16),
          child: latestPost.when(
            data: (data) => GrimityPostFeed(posts: data),
            loading: () => Skeletonizer(child: GrimityPostFeed(posts: Post.emptyList)),
            error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(latestPostDataProvider)),
          ),
        ),
      ],
    );
  }
}
