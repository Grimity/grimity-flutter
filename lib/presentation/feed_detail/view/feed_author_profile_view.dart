import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/extension/build_context_extension.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/extension/user_ui_extension.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_author_feeds_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 피드 작가 프로필 View
class FeedAuthorProfileView extends ConsumerWidget {
  const FeedAuthorProfileView({super.key, required this.author});

  final User author;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider(author.url));
    final profile = profileAsync.value;
    final feedAuthorId = profile?.id.isNotEmpty == true ? profile!.id : author.id;
    final feedsAsync = ref.watch(feedAuthorFeedsDataProvider(feedAuthorId));

    // 프로필 정보, 피드 정보 중 하나라도 에러 시.
    if (profileAsync.hasError || feedsAsync.hasError) {
      return GrimityStateView.error(
        onTap: () {
          if (profileAsync.hasError) {
            ref.invalidate(profileDataProvider(author.url));
          }

          if (feedsAsync.hasError) {
            ref.invalidate(feedAuthorFeedsDataProvider(feedAuthorId));
          }
        },
      );
    }

    // 프로필 정보, 피드 정보 중 하나라도 로딩 시.
    if (profileAsync.isLoading || feedsAsync.isLoading) {
      return Column(
        spacing: GdsSpacing.spacing12,
        children: [
          Skeletonizer(child: _AuthorProfile(profile: User.empty())),
          Skeletonizer(child: _AuthorFeeds(feeds: Feed.createEmptyList(context), profile: User.empty())),
        ],
      );
    }

    final feeds = feedsAsync.value?.feeds ?? Feed.createEmptyList(context);

    return Column(
      spacing: GdsSpacing.spacing12,
      children: [
        _AuthorProfile(profile: profile),
        _AuthorFeeds(feeds: feeds, profile: profile),
      ],
    );
  }
}

class _AuthorProfile extends ConsumerWidget {
  const _AuthorProfile({required this.profile});

  final User? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFollowing = profile?.isFollowing ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      child: GdsUserItem.follow(
        nickName: profile?.name ?? '',
        personAvatar: profile?.personAvatar ?? GdsPersonAvatar(),
        followUserInfo: GdsFollowUserInfo(
          followerCount: profile?.followerCount ?? 0,
          showFollowing: false,
        ),
        primaryActionButton: GdsOutlinedButton(
          size: GdsOutlinedButtonSize.small,
          text: '작품 보기',
          onPressed: () => goProfile(context),
        ),
        secondaryActionButton: GdsSolidButton(
          size: GdsSolidButtonSize.small,
          text: isFollowing ? '언팔로잉' : '팔로잉',
          onPressed: () => toggleFollow(ref),
        ),
      ),
    );
  }

  void toggleFollow(WidgetRef ref) {
    if (profile != null) {
      ref.read(profileDataProvider(profile!.url).notifier).toggleFollow();
    }
  }

  void goProfile(BuildContext context) {
    if (profile != null) {
      ProfileRoute(url: profile!.url).push(context);
    }
  }
}

class _AuthorFeeds extends ConsumerWidget {
  const _AuthorFeeds({
    required this.feeds,
    required this.profile,
  });

  final List<Feed> feeds;
  final User? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20;

        double itemWidth = (constraints.maxWidth - padding * 2) / context.feedRowCount;
        itemWidth -= GdsSpacing.spacing16;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: GdsSpacing.spacing16,
            children: [
              ...feeds.map((feed) {
                return SizedBox(
                  width: itemWidth,
                  child: GrimityImageFeed(feed: feed, authorName: profile?.name),
                );
              }),
              _buildMoreFeedsButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoreFeedsButton(BuildContext context) {
    final colors = context.gdsColors;

    return GdsGesture(
      onTap: () => ProfileRoute(url: profile!.url).push(context),
      child: Container(
        width: 90,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: GdsSpacing.spacing10,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(GdsRadius.md),
                color: colors.surface.primarySubtlest,
              ),
              child: Transform.translate(
                offset: Offset(1, 0),
                child: GdsIcon.chevronRight.build(
                  width: GdsSpacing.spacing16,
                  height: GdsSpacing.spacing16,
                  color: colors.surface.primaryNormal,
                ),
              ),
            ),
            Text(
              '작품\n더보기',
              textAlign: TextAlign.center,
              style: GdsTypography.label3.copyWith(color: colors.text.primaryNormal),
            ),
          ],
        ),
      ),
    );
  }
}
