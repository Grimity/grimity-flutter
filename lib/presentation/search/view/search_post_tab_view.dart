import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_pagination_widget.dart';
import 'package:grimity/presentation/common/widget/grimity_post_feed.dart';
import 'package:grimity/presentation/common/widget/system/sort/grimity_search_sort_header.dart';
import 'package:grimity/presentation/search/provider/search_post_data_provider.dart';
import 'package:grimity/presentation/search/widget/search_empty_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchPostTabView extends HookConsumerWidget with SearchPostMixin {
  const SearchPostTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return searchPostState(ref).maybeWhen(
      data: (posts) => posts.totalCount == 0 ? SearchEmptyWidget() : _SearchResultPostView(posts: posts),
      orElse: () => GrimityCircularProgressIndicator(),
    );
  }
}

class _SearchResultPostView extends HookConsumerWidget with SearchPostMixin {
  const _SearchResultPostView({required this.posts});

  final Posts posts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final searchNotifier = searchPostNotifier(ref);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          sliver: SliverToBoxAdapter(child: _SearchPostSortHeader(resultCount: posts.totalCount ?? 0)),
        ),
        SliverToBoxAdapter(child: _SearchPostList(posts: posts.posts, keyword: searchNotifier.keyword)),
        SliverToBoxAdapter(
          child: GrimityPaginationWidget(
            currentPage: searchNotifier.currentPage,
            size: searchNotifier.size,
            totalCount: posts.totalCount ?? 0,
            onPageSelected: (page) => searchPostNotifier(ref).goToPage(page),
          ),
        ),
      ],
    );
  }
}

class _SearchPostSortHeader extends StatelessWidget {
  const _SearchPostSortHeader({required this.resultCount});

  final int resultCount;

  @override
  Widget build(BuildContext context) {
    return GrimitySearchSortHeader(resultCount: resultCount, padding: EdgeInsets.zero);
  }
}

class _SearchPostList extends StatelessWidget {
  const _SearchPostList({required this.posts, required this.keyword});

  final List<Post> posts;
  final String keyword;

  @override
  Widget build(BuildContext context) {
    return GrimityPostFeed(posts: posts, cardHorizontalPadding: 16, keyword: keyword);
  }
}
