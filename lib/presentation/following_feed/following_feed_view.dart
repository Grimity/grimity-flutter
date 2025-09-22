import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/following_feed/provider/following_feed_data_provider.dart';
import 'package:grimity/presentation/home/hook/use_infinite_scroll_hook.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FollowingFeedView extends HookConsumerWidget {
  const FollowingFeedView({super.key, required this.followFeedAppbar, required this.followingFeedListView});

  final Widget followFeedAppbar;
  final Widget followingFeedListView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useInfiniteScrollHook(
      ref: ref,
      scrollController: scrollController,
      loadFunction: () async => await ref.read(followingFeedDataProvider.notifier).loadMore(),
    );

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [followFeedAppbar],
      body: GrimityRefreshIndicator(
        onRefresh: () async {
          await Future.wait([ref.refresh(followingFeedDataProvider.future)]);
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [SliverToBoxAdapter(child: followingFeedListView)],
        ),
      ),
    );
  }
}
