import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_feed_grid.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/storage/provider/storage_like_feed_data_provider.dart';
import 'package:grimity/presentation/storage/provider/storage_save_feed_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StorageSaveFeedView extends HookConsumerWidget {
  const StorageSaveFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final saveFeed = ref.watch(saveFeedDataProvider);

    return saveFeed.when(
      data: (data) {
        final feeds = data.feeds;

        if (feeds.isEmpty) {
          return GdsEmptyState(
            size: context.isMobile ? GdsEmptyStateSize.md : GdsEmptyStateSize.xl,
            icon: GdsIcon.resultNull,
            title: '저장한 그림이 없어요',
            action: GdsSolidButton(
              size: context.isMobile ? GdsSolidButtonSize.regular : GdsSolidButtonSize.large,
              text: '인기 그림 둘러보기',
              onPressed: () => RankingRoute().go(context),
            ),
          );
        }

        return GrimityInfiniteScrollPagination(
          isEnabled: data.nextCursor != null,
          onLoadMore: ref.read(likeFeedDataProvider.notifier).loadMore,
          child: _StorageSaveFeedListView(feeds: feeds),
        );
      },
      loading: () => Skeletonizer(child: _StorageSaveFeedListView(feeds: Feed.createEmptyList(context))),
      error: (error, stackTrace) => GrimityStateView.error(onTap: () => ref.invalidate(likeFeedDataProvider)),
    );
  }
}

class _StorageSaveFeedListView extends StatelessWidget {
  const _StorageSaveFeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        GrimityFeedGrid.sliver(
          feeds: feeds,
          padding: context.isMobile
              ? EdgeInsets.all(GdsSpacing.spacing16)
              : EdgeInsets.symmetric(
                  vertical: GdsSpacing.spacing24,
                  horizontal: GdsSpacing.spacing20,
                ),
        ),
      ],
    );
  }
}
