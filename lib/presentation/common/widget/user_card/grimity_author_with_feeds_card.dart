import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/provider/author_with_feeds_provider.dart';

/// 추천 작가 Card
class GrimityAuthorWithFeedsCard extends StatelessWidget {
  const GrimityAuthorWithFeedsCard({
    super.key,
    required this.authorWithFeeds,
    required this.onFollowTab,
  });

  final AuthorWithFeeds authorWithFeeds;
  final VoidCallback onFollowTab;

  /// 추천 작가의 프로필 페이지로 이동.
  void _goProfile(BuildContext context) {
    final user = authorWithFeeds.user;
    ProfileRoute(url: user.url).push(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = authorWithFeeds.user;
    final feeds = authorWithFeeds.feeds;
    final latestThumbnails =
        feeds.take(3).map((feed) => GdsUserCardThumbnailData(imageUrl: feed.thumbnail ?? '')).toList();

    while (latestThumbnails.length < 3) {
      latestThumbnails.add(const GdsUserCardThumbnailData(imageUrl: ''));
    }

    return GdsUserCard(
      type: GdsUserCardType.defaultType,
      nickname: user.name,
      profileImageUrl: user.image,
      followerCount: user.followerCount ?? 0,
      followingCount: user.followingCount,
      latestThumbnails: latestThumbnails,
      actionLabel: (user.isFollowing ?? false) ? '언팔로우' : '팔로우',
      onActionPressed: onFollowTab,
      onTap: () => _goProfile(context),
    );
  }
}
