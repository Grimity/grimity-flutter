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
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: postsAsync.when(
              data: (data) => _buildPostGrid(context, data),
              loading: () => Skeletonizer(child: _buildPostGrid(context, Post.emptyList)),
              error:
                  (error, stack) =>
                      GrimityStateView.error(onTap: () => ref.invalidate(profilePostsDataProvider(user.id))),
            ),
          ),
        ],
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
}
