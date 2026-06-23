import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/extension/build_context_extension.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/album_edit/widget/album_edit.dart';
import 'package:grimity/presentation/album_organize/provider/album_feed_data_provider.dart';
import 'package:grimity/presentation/album_organize/provider/album_organize_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:collection/collection.dart';

class AlbumOrganizeBodyView extends HookConsumerWidget with AlbumOrganizeMixin {
  const AlbumOrganizeBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final colors = context.gdsColors;
    final state = albumOrganizeState(ref);
    final user = state.user;
    final userAlbums = state.userAlbums;
    final currentAlbumId = state.currentAlbumId;
    final currentAlbum = userAlbums.firstWhereOrNull((e) => e.id == currentAlbumId);
    final albumFeeds = ref.watch(albumFeedDataProvider(user.id, currentAlbumId));

    return Stack(
      children: [
        GrimityInfiniteScrollPagination(
          isEnabled: user.id.isNotEmpty && (albumFeeds.value?.nextCursor?.isNotEmpty ?? false),
          onLoadMore: ref.read(albumFeedDataProvider(user.id, currentAlbumId).notifier).loadMore,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  context.isMobile
                      ? EdgeInsets.all(GdsSpacing.spacing16)
                      : EdgeInsets.only(
                        top: GdsSpacing.spacing24,
                        left: GdsSpacing.spacing20,
                        right: GdsSpacing.spacing20,
                        bottom: GdsSpacing.spacing20,
                      ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing12,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentAlbum?.name ?? '전체 앨범',
                        style:
                            context.isMobile
                                ? GdsTypography.title2.copyWith(color: colors.text.grayBold)
                                : GdsTypography.title1.copyWith(color: colors.text.grayBold),
                      ),
                      GdsTextButton(
                        text: '앨범명 변경',
                        size: GdsTextButtonSize.regular,
                        enabled: currentAlbum != null,
                        variant: GdsTextButtonVariant.assistive,
                        trailingIcon: GdsIcon.pen2Outline,
                        onPressed:
                            () => showAlbumEdit(
                              context,
                              currentAlbum!,
                              ref,
                              onEdited: albumOrganizeNotifier(ref).updateAlbum,
                            ),
                      ),
                    ],
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
                    error:
                        (error, stackTrace) => GrimityStateView.error(
                          onTap: () => ref.invalidate(albumFeedDataProvider(user.id, currentAlbumId)),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: GdsSpacing.spacing24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing16,
              children: [
                GdsSolidButton(
                  text: '선택 삭제',
                  size: GdsSolidButtonSize.large,
                  enabled: albumFeeds.value?.feeds.isNotEmpty ?? false,
                  rounded: true,
                  leadingIcon: GdsIcon.trash,
                  onPressed: () {
                    if (state.ids.isEmpty) {
                      ToastService.show('삭제할 그림을 선택해주세요', GdsToastType.info);
                      return;
                    }

                    final alert = GdsAlert(
                      size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
                      title: '선택한 그림을 삭제할까요?',
                      description: '삭제 이후 되돌릴 수 없어요',
                      primaryLabel: '삭제하기',
                      secondaryLabel: '아니요',
                      onPrimaryTap: () {
                        Navigator.pop(context);
                        albumOrganizeNotifier(ref).deleteFeeds();
                      },
                      onSecondaryTap: () => Navigator.pop(context),
                    );

                    alert.open(context);
                  },
                ),
                GdsSolidButton(
                  text: '앨범 이동',
                  size: GdsSolidButtonSize.large,
                  enabled: albumFeeds.value?.feeds.isNotEmpty ?? false,
                  rounded: true,
                  leadingIcon: GdsIcon.forward,
                  onPressed: () {
                    if (state.ids.isEmpty) {
                      ToastService.show('이동할 그림을 선택해주세요', GdsToastType.info);
                      return;
                    }

                    String? selectedAlbumId = '';

                    final child = StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: GdsSpacing.spacing8,
                          children: [
                            GdsListItem.optionCard(
                              text: '전체 앨범',
                              state:
                                  currentAlbum != null
                                      ? selectedAlbumId == null
                                          ? GdsListItemState.pressed
                                          : GdsListItemState.enabled
                                      : GdsListItemState.disabled,
                              onTap: currentAlbum != null ? () => setState(() => selectedAlbumId = null) : () => {},
                            ),
                            ...userAlbums.map(
                              (album) => GdsListItem.optionCard(
                                text: album.name,
                                state:
                                    album.id == currentAlbumId
                                        ? GdsListItemState.disabled
                                        : selectedAlbumId == album.id
                                        ? GdsListItemState.pressed
                                        : GdsListItemState.enabled,
                                onTap:
                                    album.id == currentAlbumId
                                        ? () => {}
                                        : () => setState(() => selectedAlbumId = album.id),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    onPrimaryTap() {
                      if (selectedAlbumId == '' || selectedAlbumId == currentAlbumId) {
                        ToastService.show('이동할 앨범을 선택해주세요', GdsToastType.info);
                        return;
                      }

                      albumOrganizeNotifier(ref).updateTargetAlbumId(selectedAlbumId);
                      Navigator.pop(context);
                      albumOrganizeNotifier(ref).moveFeeds();
                    }

                    if (context.isMobile) {
                      final bottomSheet = GdsBottomSheet(
                        title: '앨범 이동',
                        primaryLabel: '이동하기',
                        secondaryLabel: '닫기',
                        onPrimaryTap: onPrimaryTap,
                        onSecondaryTap: () => Navigator.pop(context),
                        child: child,
                      );

                      bottomSheet.open(context);
                    } else {
                      final modal = GdsModal(
                        title: '앨범 이동',
                        primaryLabel: '이동하기',
                        secondaryLabel: '닫기',
                        onPrimary: onPrimaryTap,
                        onSecondary: () => Navigator.pop(context),
                        onClose: () => Navigator.pop(context),
                        body: child,
                      );

                      modal.open(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableFeedGrid(
    BuildContext context,
    WidgetRef ref, {
    bool isSkeleton = false,
    required List<Feed> feeds,
  }) {
    final colors = context.gdsColors;
    final state = albumOrganizeState(ref);

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: GdsSpacing.spacing12,
      children: [
        Row(
          spacing: GdsSpacing.spacing2,
          children: [
            Text('그림', style: GdsTypography.label4.copyWith(color: colors.surface.grayNormal)),
            Text('${feeds.length}', style: GdsTypography.label4.copyWith(color: colors.surface.grayBold)),
          ],
        ),
        if (feeds.isNotEmpty) ...[
          DynamicHeightGridView(
            crossAxisCount: context.feedRowCount,
            crossAxisSpacing: GdsSpacing.spacing16,
            mainAxisSpacing: GdsSpacing.spacing16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: feeds.length,
            builder: (context, index) {
              final feed = feeds[index];
              final containFeed = state.ids.contains(feed.id);
              final child = GdsAlbumCard(
                width: double.infinity,
                title: feed.title,
                nickname: feed.author?.name ?? state.user.name,
                heartCount: feed.likeCount,
                viewCount: feed.viewCount,
                imageUrl: feed.thumbnail ?? '',
                type: GdsAlbumCardType.check,
                state: containFeed ? GdsAlbumCardState.checked : GdsAlbumCardState.defaultType,
                onTap: () => albumOrganizeNotifier(ref).toggleFeed(feed.id),
              );

              return isSkeleton ? Skeletonizer(child: child) : child;
            },
          ),
        ] else ...[
          GdsEmptyState(
            size: context.isMobile ? GdsEmptyStateSize.md : GdsEmptyStateSize.xl,
            icon: GdsIcon.resultNull,
            title: '업로드한 그림이 없어요',
          ),
        ],
      ],
    );
  }
}
