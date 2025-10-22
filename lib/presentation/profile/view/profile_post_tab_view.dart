import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_feed.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/profile/provider/profile_posts_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePostTabView extends HookConsumerWidget {
  const ProfilePostTabView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final postsAsync = ref.watch(profilePostsDataProvider(user.id));

    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: postsAsync.when(
        data: (data) => _buildPostGrid(context, data),
        loading: () => Skeletonizer(child: _buildPostGrid(context, Post.emptyList)),
        error:
            (error, stack) => ListView(
              children: [GrimityStateView.error(onTap: () => ref.invalidate(profilePostsDataProvider(user.id)))],
            ),
      ),
    );
  }

  Widget _buildPostGrid(BuildContext context, List<Post> posts) {
    if (posts.isNotEmpty) {
      return GrimityPostFeed(posts: posts);
    } else {
      return GrimityStateView.illust(
        subTitle: '첫 게시글을 업로드해보세요',
        buttonText: '게시글 업로드',
        onTap: () => PostUploadRoute().push(context),
      );
    }
  }

  double calculateAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 32.w;
    final crossAxisSpacing = 12.w;
    final availableWidth = screenWidth - horizontalPadding;
    final itemWidth = (availableWidth - crossAxisSpacing) / 2;

    final textAreaHeight = 8 + (14.sp * 1.4) + 2 + (12.sp * 1.4);

    return itemWidth / (itemWidth + textAreaHeight);
  }
}
