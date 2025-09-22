import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/home/hook/use_infinite_scroll_hook.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({
    super.key,
    required this.homeAppBar,
    required this.noticeView,
    required this.feedRankingView,
    required this.latestPostView,
    required this.latestFeedView,
  });

  final Widget homeAppBar;
  final Widget noticeView;
  final Widget feedRankingView;
  final Widget latestPostView;
  final Widget latestFeedView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useInfiniteScrollHook(
      ref: ref,
      scrollController: scrollController,
      loadFunction: () async => await ref.read(latestFeedDataProvider.notifier).loadMore(),
    );

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [homeAppBar],
      body: GrimityRefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(feedRankingDataProvider.future),
            ref.refresh(latestPostDataProvider.future),
            ref.refresh(latestFeedDataProvider.future),
          ]);
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(child: Gap(16)),
            SliverToBoxAdapter(child: noticeView),
            SliverToBoxAdapter(child: Gap(24)),
            SliverToBoxAdapter(child: feedRankingView),
            SliverToBoxAdapter(child: Gap(50)),
            SliverToBoxAdapter(child: latestPostView),
            SliverToBoxAdapter(child: Gap(50)),
            SliverToBoxAdapter(child: latestFeedView),
            SliverToBoxAdapter(child: Gap(16)),
          ],
        ),
      ),
    );
  }
}
