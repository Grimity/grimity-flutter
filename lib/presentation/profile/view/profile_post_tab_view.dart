import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_feed.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';
import 'package:grimity/presentation/profile/provider/profile_posts_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_view_type_argument_provider.dart';
import 'package:grimity/presentation/profile/widget/profile_sort_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePostTabView extends HookConsumerWidget {
  const ProfilePostTabView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final postsAsync = ref.watch(profilePostsDataProvider(user.id));
    final viewType = ref.watch(profileViewTypeArgumentProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Gap(context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20),
        ),
        SliverToBoxAdapter(
          child: ProfileSortHeader(
            itemCount: user.postCount ?? 0,
            sortItems: SortType.profilePostSortValues,
            sortValue: SortType.latest,
            isSortEnabled: (postsAsync.value ?? []).isNotEmpty,
            albumOrganize: false,
          ),
        ),
        postsAsync.when(
          data: (posts) => _buildPostGrid(context, viewType, posts),
          loading: () => Skeletonizer.sliver(child: _buildPostGrid(context, viewType, Post.emptyList)),
          error: (_, _) {
            return SliverToBoxAdapter(
              child: GrimityStateView.error(onTap: () => ref.invalidate(profilePostsDataProvider(user.id))),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPostGrid(
    BuildContext context,
    ProfileViewType viewType,
    List<Post> posts,
  ) {
    if (posts.isNotEmpty) {
      return GrimityPostFeed(
        posts: posts,
        isSliver: true,
        isBookMark: true,
        showPostType: true,
        cardHorizontalPadding: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      );
    } else {
      if (viewType == ProfileViewType.mine) {
        return SliverToBoxAdapter(
          child: GdsEmptyState(
            title: '첫 글을 업로드해보세요',
            icon: GdsIcon.illustReply,
            size: context.isMobile ? GdsEmptyStateSize.md : GdsEmptyStateSize.xl,
            action: GdsSolidButton(
              text: '글 업로드',
              size: context.isMobile ? GdsSolidButtonSize.regular : GdsSolidButtonSize.large,
              onPressed: () => PostUploadRoute().push(context),
            ),
          ),
        );
      }

      // Other
      return SliverToBoxAdapter(
        child: GdsEmptyState(
          title: '업로드한 글이 없어요',
          icon: GdsIcon.resultNull,
          size: context.isMobile ? GdsEmptyStateSize.md : GdsEmptyStateSize.xl,
        ),
      );
    }
  }
}
