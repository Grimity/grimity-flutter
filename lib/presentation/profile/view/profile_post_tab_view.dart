import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_post_feed.dart';
import 'package:grimity/presentation/profile/provider/profile_posts_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePostTabView extends HookConsumerWidget {
  const ProfilePostTabView({super.key, required this.user, this.isMine = false});

  final User user;
  final bool isMine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final postsAsync = ref.watch(profilePostsDataProvider(user.id));

    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: postsAsync.when(
        data: (data) => _buildPostGrid(context, data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildPostGrid(context, []),
      ),
    );
  }

  Widget _buildPostGrid(BuildContext context, List<Post> posts) {
    if (posts.isNotEmpty) {
      return GrimityPostFeed(posts: posts);
    } else {
      if (!isMine) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('아직 업로드한 글이 없어요', style: AppTypeface.label2.copyWith(color: AppColor.gray600))],
          ),
        );
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.profile.illust.svg(width: 60.w, height: 60.w),
            Gap(16),
            Text('첫 게시글을 업로드해보세요', style: AppTypeface.label2.copyWith(color: AppColor.gray600)),
            Gap(16),
          ],
        ),
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
