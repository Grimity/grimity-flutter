import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    super.key,
    required this.homeAppBar,
    required this.noticeView,
    required this.feedRankingView,
    required this.latestPostView,
    required this.latestFeedTitle,
    required this.latestFeedView,
  });

  final Widget homeAppBar;
  final Widget noticeView;
  final Widget feedRankingView;
  final Widget latestPostView;
  final Widget latestFeedTitle;
  final Widget latestFeedView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: GrimityInfiniteScrollPagination(
          isEnabled: ref.watch(latestFeedDataProvider).valueOrNull?.nextCursor != null,
          onLoadMore: ref.read(latestFeedDataProvider.notifier).loadMore,
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: GdsSpacing.spacing16)),
              SliverToBoxAdapter(child: noticeView),
              const SliverToBoxAdapter(child: SizedBox(height: GdsSpacing.spacing24)),
              SliverToBoxAdapter(child: feedRankingView),
              const SliverToBoxAdapter(child: SizedBox(height: GdsSpacing.spacing48)),
              SliverToBoxAdapter(child: latestPostView),
              const SliverToBoxAdapter(child: SizedBox(height: GdsSpacing.spacing48)),
              SliverToBoxAdapter(child: latestFeedTitle),
              const SliverToBoxAdapter(child: SizedBox(height: GdsSpacing.spacing16)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: GdsSpacing.spacing16),
                sliver: latestFeedView,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: GdsSpacing.spacing16)),
            ],
          ),
        ),
      ),
    );
  }
}
