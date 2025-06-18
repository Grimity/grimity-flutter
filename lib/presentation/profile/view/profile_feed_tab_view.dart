import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';
import 'package:grimity/presentation/profile/provider/profile_feeds_data_provider.dart';
import 'package:grimity/presentation/profile/provider/selected_album_provider.dart';
import 'package:grimity/presentation/profile/widget/album_chip.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileFeedTabView extends HookConsumerWidget {
  const ProfileFeedTabView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final feedsAsync = ref.watch(profileFeedsDataProvider(user.id));
    final selectedAlbumId = ref.watch(selectedAlbumProvider);

    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(12),
          Row(
            children: [
              _ProfileAlbumHeader(albums: user.albums ?? [], selectedAlbumId: selectedAlbumId),
              Gap(8),
              _buildAlbumEdit(),
            ],
          ),
          _buildMenu(),
          Expanded(
            child: feedsAsync.when(
              data: (data) => _buildFeedGrid(context, data.feeds),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildFeedGrid(context, []),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.profile.illust.svg(width: 60.w, height: 60.w),
            Gap(16),
            Text('첫 그림을 업로드해보세요', style: AppTypeface.label2.copyWith(color: AppColor.gray600)),
            Gap(16),
          ],
        ),
      );
    }
  }

  Widget _buildAlbumEdit() {
    return GestureDetector(
      onTap: () {},
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

  Widget _buildMenu() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: Row(
              children: [
                Text('그림 정리', style: AppTypeface.caption2.copyWith(color: AppColor.gray700)),
                Gap(6),
                Assets.icons.profile.sync.svg(width: 16, height: 16),
              ],
            ),
          ),
          Gap(16),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: Row(
              children: [
                Text('최신순', style: AppTypeface.caption2.copyWith(color: AppColor.gray700)),
                Gap(6),
                Assets.icons.profile.arrowDown.svg(width: 16, height: 16),
              ],
            ),
          ),
        ],
      ),
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
