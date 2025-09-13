import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/album_organize/provider/album_feed_data_provider.dart';
import 'package:grimity/presentation/album_organize/provider/album_organize_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_selectable_image_feed.dart';
import 'package:grimity/presentation/home/hook/use_infinite_scroll_hook.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AlbumOrganizeBodyView extends HookConsumerWidget with AlbumOrganizeMixin {
  const AlbumOrganizeBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final scrollController = useScrollController();
    final state = albumOrganizeState(ref);
    final user = state.user;
    final currentAlbumId = state.currentAlbumId;
    final userAlbums = state.userAlbums;
    final albumFeeds = ref.watch(albumFeedDataProvider(user.id, currentAlbumId));

    if (user.id.isNotEmpty) {
      useInfiniteScrollHook(
        ref: ref,
        scrollController: scrollController,
        loadFunction: () async {
          final currentState = ref.read(albumFeedDataProvider(user.id, currentAlbumId)).valueOrNull;
          if (currentState != null && currentState.nextCursor != null && currentState.nextCursor!.isNotEmpty) {
            await ref.read(albumFeedDataProvider(user.id, currentAlbumId).notifier).loadMore();
          }
        },
      );
    }

    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentAlbumId == null ? '전체 앨범' : userAlbums.firstWhere((e) => e.id == currentAlbumId).name,
              style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800),
            ),
            Gap(16),
            Padding(
              padding: EdgeInsets.only(bottom: 52),
              child: albumFeeds.when(
                data: (data) => _buildSelectableFeedGrid(context, ref, feeds: data.feeds),
                loading: () => Skeletonizer(child: _buildSelectableFeedGrid(context, ref, feeds: Feed.emptyList)),
                error: (error, stackTrace) => _buildSelectableFeedGrid(context, ref, feeds: []),
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
