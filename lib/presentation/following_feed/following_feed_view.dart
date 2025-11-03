import 'package:flutter/material.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/following_feed/provider/following_feed_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FollowingFeedView extends ConsumerWidget {
  const FollowingFeedView({super.key, required this.followFeedAppbar, required this.followingFeedListView});

  final Widget followFeedAppbar;
  final Widget followingFeedListView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [followFeedAppbar],
      body: GrimityRefreshIndicator(
        onRefresh: () async {
          await Future.wait([ref.refresh(followingFeedDataProvider.future)]);
        },
        child: GrimityInfiniteScrollPagination(
          isEnabled: ref.watch(followingFeedDataProvider).valueOrNull?.nextCursor != null,
          onLoadMore: ref.read(followingFeedDataProvider.notifier).loadMore,
          child: CustomScrollView(slivers: [SliverToBoxAdapter(child: followingFeedListView)]),
        ),
      ),
    );
  }
}
