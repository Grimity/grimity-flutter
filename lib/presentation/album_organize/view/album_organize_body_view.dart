import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Text(
                currentAlbumId == null ? '전체 앨범' : userAlbums.firstWhere((e) => e.id == currentAlbumId).name,
                style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800),
              ),
            ),
            SliverToBoxAdapter(child: Gap(16)),
            SliverToBoxAdapter(
              child: albumFeeds.when(
                data: (data) => _buildSelectableFeedGrid(context, ref, feeds: data.feeds),
                loading: () => Skeletonizer(child: _buildSelectableFeedGrid(context, ref, feeds: Feed.emptyList)),
                error:
                    (error, stackTrace) => GrimityStateView.error(
                      onTap: () => ref.invalidate(albumFeedDataProvider(user.id, currentAlbumId)),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableFeedGrid(BuildContext context, WidgetRef ref, {required List<Feed> feeds}) {
    final state = albumOrganizeState(ref);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 20),
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        final feed = feeds[index];
        final containFeed = state.ids.contains(feed.id);

        return GrimitySelectableImageFeed(
          feed: feed,
          authorName: state.user.name,
          selected: containFeed,
          onToggleSelected: () => albumOrganizeNotifier(ref).toggleFeed(feed.id),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 20.w,
        childAspectRatio: _calculateAspectRatio(context),
      ),
    );
  }

  double _calculateAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 32.w;
    final crossAxisSpacing = 12.w;
    final availableWidth = screenWidth - horizontalPadding;
    final itemWidth = (availableWidth - crossAxisSpacing) / 2;

    final textAreaHeight = 8 + (14.sp * 1.4) + 2 + (12.sp * 1.4);

    return itemWidth / (itemWidth + textAreaHeight);
  }
}
