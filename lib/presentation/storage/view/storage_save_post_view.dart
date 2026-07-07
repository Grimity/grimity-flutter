import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_card.dart';
import 'package:grimity/presentation/storage/provider/storage_save_post_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StorageSavePostView extends HookConsumerWidget {
  const StorageSavePostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final savePost = ref.watch(savePostDataProvider);

    return savePost.when(
      data: (data) {
        final posts = data.posts;

        if (posts.isEmpty) {
          return GdsEmptyState(
            size: context.isMobile ? GdsEmptyStateSize.md : GdsEmptyStateSize.xl,
            icon: GdsIcon.resultNull,
            title: '저장한 글이 없어요',
            action: GdsSolidButton(
              size: context.isMobile ? GdsSolidButtonSize.regular : GdsSolidButtonSize.large,
              text: '자유게시판 둘러보기',
              onPressed: () => BoardRoute().go(context),
            ),
          );
        }

        return GrimityInfiniteScrollPagination(
          onLoadMore: ref.read(savePostDataProvider.notifier).loadMore,
          isEnabled: posts.length < (data.totalCount ?? posts.length),
          child: _StorageSavePostListView(posts: posts),
        );
      },
      loading: () => Skeletonizer(child: _StorageSavePostListView(posts: Post.emptyList)),
      error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(savePostDataProvider)),
    );
  }
}

class _StorageSavePostListView extends StatelessWidget {
  const _StorageSavePostListView({required this.posts});

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return GrimityPostCard(
          post: post,
          isBookMark: true,
          showBookMark: true,
          showPostType: true,
        );
      },
    );
  }
}
