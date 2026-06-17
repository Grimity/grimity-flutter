import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/following_feed/provider/following_feed_data_provider.dart';
import 'package:grimity/presentation/following_feed/widget/following_feed_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FollowingFeedListView extends ConsumerWidget {
  const FollowingFeedListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingFeedAsync = ref.watch(followingFeedDataProvider);
    final user = ref.watch(userAuthProvider);

    return followingFeedAsync.when(
      data: (feeds) {
        final feedList = feeds.feeds;

        if (feedList.isEmpty) {
          final hasFollowing = user?.followingCount == 0;

          return SliverToBoxAdapter(
            child: GdsEmptyState(
              size: context.isMobile ? GdsEmptyStateSize.md : GdsEmptyStateSize.xl,
              icon: GdsIcon.user,
              title: hasFollowing ? '팔로우한 작가가 없어요' : '아직 올라온 그림이 없어요.',
              description: '관심 있는 작가를 팔로우하고\n새로운 작품 소식을 받아보세요',
              action: GdsSolidButton(
                size: context.isMobile ? GdsSolidButtonSize.regular : GdsSolidButtonSize.large,
                text: '인기 그림 보러가기',
                onPressed: () => const RankingRoute().go(context),
              ),
            ),
          );
        }

        return _FeedListView(feeds: feedList);
      },
      loading: () {
        return Skeletonizer.sliver(child: _FeedListView(feeds: Feed.createEmptyList(context)));
      },
      error: (e, s) {
        return SliverToBoxAdapter(
          child: GrimityStateView.error(onTap: () => ref.invalidate(followingFeedDataProvider)),
        );
      },
    );
  }
}

class _FeedListView extends StatelessWidget {
  const _FeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context) {
    final padding = context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20;

    // 스크롤 내부 가로 크기 제한 및 중앙 정렬
    return SliverCrossAxisGroup(
      slivers: [
        SliverCrossAxisExpanded(flex: 1, sliver: SliverToBoxAdapter()),
        SliverConstrainedCrossAxis(
          maxExtent: 600,
          sliver: SliverPadding(
            padding: EdgeInsets.only(
              left: padding,
              right: padding,
              bottom: padding,
            ),
            sliver: SliverList.separated(
              separatorBuilder: (_, _) => SizedBox(height: GdsSpacing.spacing24),
              itemBuilder: (_, index) => FollowingFeedCard(feed: feeds[index]),
              itemCount: feeds.length,
            ),
          ),
        ),
        SliverCrossAxisExpanded(flex: 1, sliver: SliverToBoxAdapter()),
      ],
    );
  }
}
