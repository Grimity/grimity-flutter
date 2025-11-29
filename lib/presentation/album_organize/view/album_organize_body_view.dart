import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/extension/build_context_extension.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/album_organize/provider/album_feed_data_provider.dart';
import 'package:grimity/presentation/album_organize/provider/album_organize_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_selectable_image_feed.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AlbumOrganizeBodyView extends HookConsumerWidget with AlbumOrganizeMixin {
  const AlbumOrganizeBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final state = albumOrganizeState(ref);
    final user = state.user;
    final currentAlbumId = state.currentAlbumId;
    final userAlbums = state.userAlbums;
    final albumFeeds = ref.watch(albumFeedDataProvider(user.id, currentAlbumId));

    return GrimityInfiniteScrollPagination(
      isEnabled: user.id.isNotEmpty && albumFeeds.valueOrNull?.nextCursor != null,
      onLoadMore: ref.read(albumFeedDataProvider(user.id, currentAlbumId).notifier).loadMore,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                currentAlbumId == null ? '전체 앨범' : userAlbums.firstWhere((e) => e.id == currentAlbumId).name,
                style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800),
              ),
            ),
          ),
          albumFeeds.when(
            data: (data) => _buildSelectableFeedGrid(context, ref, feeds: data.feeds),
            loading:
                () => _buildSelectableFeedGrid(
                  context,
                  ref,
                  isSkeleton: true,
                  feeds: Feed.createEmptyList(context),
                ),
            error: (error, stackTrace) {
              return SliverToBoxAdapter(
                child: GrimityStateView.error(
                  onTap: () => ref.invalidate(albumFeedDataProvider(user.id, currentAlbumId)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableFeedGrid(
    BuildContext context,
    WidgetRef ref, {
    bool isSkeleton = false,
    required List<Feed> feeds,
  }) {
    final state = albumOrganizeState(ref);

    return SliverPadding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: 20,
      ),
      sliver: SliverDynamicHeightGridView(
        crossAxisCount: context.feedRowCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 20,
        itemCount: feeds.length,
        builder: (context, index) {
          final feed = feeds[index];
          final containFeed = state.ids.contains(feed.id);
          final child = GrimitySelectableImageFeed(
            feed: feed,
            authorName: state.user.name,
            selected: containFeed,
            onToggleSelected: () => albumOrganizeNotifier(ref).toggleFeed(feed.id),
          );

          return isSkeleton ? Skeletonizer(child: child) : child;
        },
      ),
    );
  }
}
