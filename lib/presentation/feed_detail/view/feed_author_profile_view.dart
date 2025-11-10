import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/grimity_image.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_user_image.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_author_feeds_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 피드 작가 프로필 View
class FeedAuthorProfileView extends ConsumerWidget {
  final User author;

  const FeedAuthorProfileView({super.key, required this.author});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider(author.url));
    final feedsAsync = ref.watch(feedAuthorFeedsDataProvider(author.id));

    // 프로필 정보, 피드 정보 중 하나라도 에러 시.
    if (profileAsync.hasError || feedsAsync.hasError) {
      return GrimityStateView.error(
        onTap: () {
          if (profileAsync.hasError) {
            ref.invalidate(profileDataProvider(author.url));
          }

          if (feedsAsync.hasError) {
            ref.invalidate(feedAuthorFeedsDataProvider(author.id));
          }
        },
      );
    }

    // 프로필 정보, 피드 정보 중 하나라도 로딩 시.
    if (profileAsync.isLoading || feedsAsync.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          spacing: 16,
          children: [
            Skeletonizer(child: _AuthorProfile(profile: User.empty())),
            Skeletonizer(child: _AuthorFeeds(feeds: Feed.emptyList, url: author.url)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        spacing: 16,
        children: [
          _AuthorProfile(profile: profileAsync.value),
          _AuthorFeeds(feeds: feedsAsync.value!.feeds, url: author.url),
        ],
      ),
    );
  }
}

class _AuthorProfile extends ConsumerWidget {
  final User? profile;

  const _AuthorProfile({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUrl = ref.read(userAuthProvider)?.url;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GrimityGesture(
            onTap: () => goProfile(context, myUrl),
            child: GrimityUserImage(imageUrl: profile?.image, size: 30),
          ),
          Gap(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GrimityGesture(
                onTap: () => goProfile(context, myUrl),
                child: Text(profile?.name ?? '', style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: '팔로워 ', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                    TextSpan(
                      text: '${profile?.followerCount ?? 0}',
                      style: AppTypeface.caption2.copyWith(color: AppColor.gray700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void goProfile(BuildContext context, String? myUrl) {
    if (profile != null) {
      AppRouter.goProfile(context, targetUrl: profile!.url, myUrl: myUrl);
    }
  }
}

class _AuthorFeeds extends ConsumerWidget {
  final List<Feed> feeds;
  final String url;

  const _AuthorFeeds({required this.feeds, required this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: BoxConstraints(maxHeight: 130),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Gap(16),
          ...feeds.map(
            (feed) => Row(
              children: [
                GrimityGesture(
                  onTap: () => FeedDetailRoute(id: feed.id).push(context),
                  child: AspectRatio(aspectRatio: 1.0, child: GrimityImage.small(imageUrl: feed.thumbnail ?? '')),
                ),
                Gap(8),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final myUrl = ref.read(userAuthProvider)?.url;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: GrimityGesture(
                  onTap: () => AppRouter.goProfile(context, targetUrl: url, myUrl: myUrl),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColor.mainSecondary),
                  child: Assets.icons.common.arrowRight.svg(
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(AppColor.main, BlendMode.srcIn),
                  ),
                ),
                Gap(10),
                Text('작품', style: AppTypeface.caption1.copyWith(color: AppColor.main)),
                Text('더보기', style: AppTypeface.caption1.copyWith(color: AppColor.main)),
              ],
            ),
          ),
          Gap(16),
        ],
      ),
    );
  }
}
