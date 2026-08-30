import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/grimity_feed_grid.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_feeds_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_view_type_argument_provider.dart';
import 'package:grimity/presentation/profile/provider/selected_album_provider.dart';
import 'package:grimity/presentation/profile/provider/selected_sort_type_provider.dart';
import 'package:grimity/presentation/profile/widget/profile_sort_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:collection/collection.dart';

class ProfileFeedTabView extends HookConsumerWidget {
  const ProfileFeedTabView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final feedsAsync = ref.watch(profileFeedsDataProvider(user.id));
    final selectedAlbumId = ref.watch(selectedAlbumProvider);
    final selectedSortType = ref.watch(selectedSortTypeProvider);
    final userAlbums = user.albums ?? [];
    final feedCount = selectedAlbumId == null
        ? user.feedCount ?? 0
        : userAlbums.firstWhereOrNull((album) => album.id == selectedAlbumId)?.feedCount ?? 0;
    final viewType = ref.watch(profileViewTypeArgumentProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Gap(context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20),
        ),
        SliverToBoxAdapter(
          child: _ProfileAlbumHeader(
            user: user,
            albums: user.albums ?? [],
            selectedAlbumId: selectedAlbumId,
            viewType: viewType,
          ),
        ),
        SliverToBoxAdapter(
          child: Gap(context.isMobile ? GdsSpacing.spacing8 : GdsSpacing.spacing12),
        ),
        SliverToBoxAdapter(
          child: ProfileSortHeader(
            itemCount: feedCount,
            sortItems: SortType.profileFeedSortValues,
            sortValue: selectedSortType,
            isSortEnabled: (feedsAsync.value?.feeds ?? []).isNotEmpty,
            albumOrganize: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Gap(context.isMobile ? GdsSpacing.spacing8 : GdsSpacing.spacing12),
        ),
        feedsAsync.when(
          data: (data) {
            return _buildFeedGrid(context, user, data.feeds, viewType);
          },
          loading: () {
            return Skeletonizer.sliver(
              child: _buildFeedGrid(context, user, Feed.createEmptyList(context), viewType),
            );
          },
          error: (_, _) {
            return SliverToBoxAdapter(
              child: GrimityStateView.error(onTap: () => ref.invalidate(profileFeedsDataProvider(user.id))),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeedGrid(
    BuildContext context,
    User user,
    List<Feed> feeds,
    ProfileViewType viewType,
  ) {
    if (feeds.isNotEmpty) {
      return GrimityFeedGrid.sliver(
        feeds: feeds,
        showHeart: viewType == ProfileViewType.other,
        authorName: user.name,
        padding: EdgeInsets.only(
          left: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
          right: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
          bottom: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
        ),
      );
    } else {
      if (viewType == ProfileViewType.mine) {
        return SliverToBoxAdapter(
          child: GdsEmptyState(
            title: '첫 그림을 업로드해보세요',
            icon: GdsIcon.illust,
            size: context.isMobile ? GdsEmptyStateSize.md : GdsEmptyStateSize.xl,
            action: GdsSolidButton(
              text: '그림 업로드',
              size: context.isMobile ? GdsSolidButtonSize.regular : GdsSolidButtonSize.large,
              onPressed: () => FeedUploadRoute().push(context),
            ),
          ),
        );
      }

      // Other
      return SliverToBoxAdapter(
        child: GdsEmptyState(
          title: '업로드한 그림이 없어요',
          icon: GdsIcon.resultNull,
          size: context.isMobile ? GdsEmptyStateSize.md : GdsEmptyStateSize.xl,
        ),
      );
    }
  }
}

class _ProfileAlbumHeader extends HookConsumerWidget {
  const _ProfileAlbumHeader({
    required this.user,
    required this.albums,
    required this.selectedAlbumId,
    required this.viewType,
  });

  final User user;
  final List<Album> albums;
  final String? selectedAlbumId;
  final ProfileViewType viewType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GdsCategoryAction? action;

    if (viewType == ProfileViewType.mine) {
      action = GdsCategoryAction(
        icon: GdsIcon.folderEdit,
        onTap: () {
          AlbumEditRoute(user.albums ?? <Album>[]).push(context).then((_) {
            ref.invalidate(profileDataProvider);
          });
        },
      );
    }

    final spacing = context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20;

    return Padding(
      padding: action != null ? EdgeInsets.only(right: spacing) : EdgeInsets.zero,
      child: GdsCategory(
        size: context.isMobile ? GdsCategorySize.md : GdsCategorySize.lg,
        padding: EdgeInsets.symmetric(horizontal: spacing),
        action: action,
        items: [
          GdsCategoryItem(
            label: '전체',
            onTap: () => ref.read(selectedAlbumProvider.notifier).selectAll(),
            isActive: selectedAlbumId == null,
          ),
          ...albums.map((album) {
            return GdsCategoryItem(
              label: '${album.name} ${album.feedCount}',
              isActive: selectedAlbumId == album.id,
              onTap: () => ref.read(selectedAlbumProvider.notifier).selectAlbum(album.id),
            );
          }),
        ],
      ),
    );
  }
}
