import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/presentation/home/hook/use_infinite_scroll_hook.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({
    super.key,
    required this.noticeView,
    required this.feedRankingView,
    required this.latestPostView,
    required this.latestFeedView,
  });

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

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          const Gap(16),
          noticeView,
          const Gap(24),
          feedRankingView,
          const Gap(50),
          latestPostView,
          const Gap(50),
          latestFeedView,
          const Gap(16),
        ],
      ),
    );
  }
}
