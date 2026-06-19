import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/provider/author_with_feeds_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/user_card/grimity_author_with_feeds_card.dart';
import 'package:grimity/presentation/following_feed/provider/following_feed_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecommendAuthorListView extends ConsumerWidget {
  const RecommendAuthorListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorWithFeedsAsync = ref.watch(authorWithFeedsDataProvider);
    final followingFeedsAsync = ref.watch(followingFeedDataProvider);
    final nextCursor = followingFeedsAsync.value?.nextCursor;
    final visible = nextCursor == null || nextCursor.isEmpty;
    final colors = context.gdsColors;

    if (!visible) {
      return SliverToBoxAdapter();
    }

    // 스크롤 내부 가로 크기 제한 및 중앙 정렬
    return SliverCrossAxisGroup(
      slivers: [
        const SliverCrossAxisExpanded(flex: 1, sliver: SliverToBoxAdapter()),
        SliverConstrainedCrossAxis(
          maxExtent: 600,
          sliver: SliverPadding(
            padding: EdgeInsets.only(
              top: GdsSpacing.spacing12,
              left: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
              right: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
              bottom: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing24,
                children: [
                  Text('인기 작가', style: GdsTypography.title1.copyWith(color: colors.text.grayBold)),
                  authorWithFeedsAsync.when(
                    data: (data) => _AuthorWithFeedsListView(authorWithFeedsList: data),
                    error: (_, _) => GrimityStateView.error(onTap: () => ref.invalidate(authorWithFeedsDataProvider)),
                    loading: () {
                      return Skeletonizer(
                        child: _AuthorWithFeedsListView(
                          authorWithFeedsList: AuthorWithFeeds.createEmptyList(context),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverCrossAxisExpanded(flex: 1, sliver: SliverToBoxAdapter()),
      ],
    );
  }
}

class _AuthorWithFeedsListView extends ConsumerWidget {
  const _AuthorWithFeedsListView({required this.authorWithFeedsList});

  final List<AuthorWithFeeds> authorWithFeedsList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicHeightGridView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: GdsSpacing.spacing16,
      crossAxisSpacing: GdsSpacing.spacing16,
      crossAxisCount: context.isMobile ? 1 : 2,
      itemCount: authorWithFeedsList.length,
      builder: (context, index) {
        final authorWithFeeds = authorWithFeedsList[index];

        return GrimityAuthorWithFeedsCard(
          authorWithFeeds: authorWithFeeds,
          onFollowTab: () {
            final feedsData = ref.read(authorWithFeedsDataProvider.notifier);

            feedsData.toggleFollow(
              id: authorWithFeeds.user.id,
              follow: authorWithFeeds.user.isFollowing == false ? true : false,
            );
          },
        );
      },
    );
  }
}
