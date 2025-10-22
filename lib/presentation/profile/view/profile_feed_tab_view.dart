import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/system/sort/grimity_search_sort_header.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_feeds_data_provider.dart';
import 'package:grimity/presentation/profile/provider/selected_album_provider.dart';
import 'package:grimity/presentation/profile/provider/selected_sort_type_provider.dart';
import 'package:grimity/presentation/profile/widget/album_chip.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileFeedTabView extends HookConsumerWidget {
  const ProfileFeedTabView({super.key, required this.user, required this.viewType});

  final User user;
  final ProfileViewType viewType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final feedsAsync = ref.watch(profileFeedsDataProvider(user.id));
    final selectedAlbumId = ref.watch(selectedAlbumProvider);
    final userAlbums = user.albums ?? [];
    final selectedAlbumFeedCount =
        selectedAlbumId == null
            ? user.feedCount ?? 0
            : userAlbums.firstWhere((album) => album.id == selectedAlbumId).feedCount ?? 0;

    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              children: [
                _ProfileAlbumHeader(albums: user.albums ?? [], selectedAlbumId: selectedAlbumId),
                Gap(8),
                if (viewType == ProfileViewType.mine) _buildAlbumEdit(context, ref),
              ],
            ),
          ),
          // 해당 앨범의 피드 갯수가 0개가 아닐때 표시
          if (selectedAlbumFeedCount != 0)
            SliverToBoxAdapter(child: _buildSortHeader(context, ref, selectedAlbumId, selectedAlbumFeedCount)),
          SliverToBoxAdapter(
            child: feedsAsync.when(
              data: (data) => _buildFeedGrid(context, data.feeds),
              loading: () => Skeletonizer(child: _buildFeedGrid(context, Feed.emptyList)),
              error:
                  (error, stack) =>
                      GrimityStateView.error(onTap: () => ref.invalidate(profileFeedsDataProvider(user.id))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedGrid(BuildContext context, List<Feed> feeds) {
    if (feeds.isNotEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 20),
        itemCount: feeds.length,
        itemBuilder: (context, index) {
          return GrimityImageFeed(feed: feeds[index], authorName: user.name);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 20.w,
          childAspectRatio: calculateAspectRatio(context),
        ),
      );
    } else {
      if (viewType == ProfileViewType.other) {
        return GrimityStateView.resultNull(subTitle: '아직 업로드한 그림이 없어요');
      }

      return GrimityStateView.illust(
        subTitle: '첫 그림을 업로드해보세요',
        buttonText: '그림 업로드',
        onTap: () => FeedUploadRoute().push(context),
      );
    }
  }

  Widget _buildAlbumEdit(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap:
          () => AlbumEditRoute(user.albums ?? <Album>[]).push(context).then((_) => ref.invalidate(profileDataProvider)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: AppColor.gray300),
        ),
        padding: EdgeInsets.all(10.w),
        child: Assets.icons.profile.editFolder.svg(width: 16, height: 16),
      ),
    );
  }

  Widget _buildSortHeader(BuildContext context, WidgetRef ref, String? selectedAlbumId, int selectedAlbumFeedCount) {
    return GrimitySearchSortHeader(
      resultCount: selectedAlbumFeedCount,
      onOrganizeTap:
          viewType == ProfileViewType.mine
              ? () => AlbumOrganizeRoute($extra: user).push(context).then((_) {
                ref.invalidate(profileFeedsDataProvider);
                ref.invalidate(profileDataProvider);
              })
              : null,
      sortValue: SortType.latest,
      sortItems:
          SortType.profileFeedSortValues
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.typeName, style: AppTypeface.caption2.copyWith(color: AppColor.gray700)),
                ),
              )
              .toList(),
      onSortChanged: (value) {
        if (value == null) return;
        ref.read(selectedSortTypeProvider.notifier).setSortType(value);
      },
      padding: EdgeInsets.zero,
    );
  }

  double calculateAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 32.w;
    final crossAxisSpacing = 12.w;
    final availableWidth = screenWidth - horizontalPadding;
    final itemWidth = (availableWidth - crossAxisSpacing) / 2;

    final textAreaHeight = 8 + (14.sp * 1.4) + 2 + (12.sp * 1.4);

    return itemWidth / (itemWidth + textAreaHeight);
  }
}

class _ProfileAlbumHeader extends HookConsumerWidget {
  const _ProfileAlbumHeader({required this.albums, required this.selectedAlbumId});

  final List<Album> albums;
  final String? selectedAlbumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 6.w,
              children: [
                AlbumChip(
                  title: '전체',
                  isSelected: selectedAlbumId == null,
                  onTap: () => ref.read(selectedAlbumProvider.notifier).selectAll(),
                ),
                ...albums.map((album) {
                  return AlbumChip(
                    title: album.name,
                    amount: album.feedCount.toString(),
                    isSelected: selectedAlbumId == album.id,
                    onTap: () => ref.read(selectedAlbumProvider.notifier).selectAlbum(album.id),
                  );
                }),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 20.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.white.withValues(alpha: 0.0), Colors.white.withValues(alpha: 0.8), Colors.white],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
