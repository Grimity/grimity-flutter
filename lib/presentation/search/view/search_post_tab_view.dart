import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_view.dart';
import 'package:grimity/presentation/search/provider/search_post_data_provider.dart';
import 'package:grimity/presentation/search/view/search_empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchPostTabView extends HookConsumerWidget with SearchPostMixin {
  const SearchPostTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return searchPostState(ref).when(
      data: (posts) {
        if (posts.totalCount == 0) {
          return SearchEmptyState();
        }

        return _SearchResultPostView(posts: posts);
      },
      loading: () => Skeletonizer(
        child: _SearchResultPostView(posts: Posts(posts: Post.emptyList, totalCount: 0)),
      ),
      error: (e, s) => GrimityStateView.error(onTap: () => invalidateSearchPost(ref)),
    );
  }
}

class _SearchResultPostView extends HookConsumerWidget with SearchPostMixin {
  const _SearchResultPostView({required this.posts});

  final Posts posts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchNotifier = searchPostNotifier(ref);

    return GrimityPostView(
      posts: posts.posts,
      totalCount: posts.totalCount ?? 0,
      currentPage: searchNotifier.currentPage,
      size: searchNotifier.size,
      onPageChanged: searchNotifier.goToPage,
      cardHorizontalPadding: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      keyword: searchNotifier.keyword,
      isBookMark: true,
      showPostType: true,
      showBookMark: true,
    );
  }
}
