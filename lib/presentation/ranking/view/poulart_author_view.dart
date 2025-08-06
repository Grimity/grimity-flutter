import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/grimity_follow_button.dart';
import 'package:grimity/presentation/common/widget/grimity_image.dart';
import 'package:grimity/presentation/common/widget/grimity_user_image.dart';
import 'package:grimity/presentation/ranking/provider/popular_author_data_provider.dart';
import 'package:grimity/presentation/ranking/provider/popular_author_feed_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 인기 작가
class PopularAuthorView extends ConsumerWidget {
  const PopularAuthorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularAuthor = ref.watch(popularAuthorDataProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('인기 작가', style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800)),
          Gap(16),
          popularAuthor.maybeWhen(
            data: (users) {
              if (users.isEmpty) return SizedBox.shrink();

              return _PopularAuthorCarousel(users: users);
            },
            orElse: () => Skeletonizer(child: _PopularAuthorCarousel(users: User.emptyList)),
          ),
        ],
      ),
    );
  }
}

class _PopularAuthorCarousel extends HookConsumerWidget {
  const _PopularAuthorCarousel({required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final visibleUserCount = users.length > 5 ? 5 : users.length;

    return Column(
      spacing: 16,
      children: [
        CarouselSlider.builder(
          itemCount: visibleUserCount,
          options: CarouselOptions(
            enableInfiniteScroll: false,
            disableCenter: true,
            height: 183.h,
            padEnds: false,
            viewportFraction: 0.93,
            onPageChanged: (index, reason) => currentIndex.value = index,
          ),
          itemBuilder: (context, index, realIndex) {
            final user = users[index];
            final feedAsync = ref.watch(popularAuthorFeedDataProvider(user.id));

            return Container(
              width: 343.w,
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.gray300, width: 1),
              ),
              child: Column(
                spacing: 20,
                children: [
                  Row(
                    children: [
                      GrimityUserImage(imageUrl: user.image, size: 30),
                      Gap(8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: '팔로워 ', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                                TextSpan(text: '${user.followerCount}', style: AppTypeface.caption1),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      // 팔로우 버튼
                      GrimityFollowButton(url: user.url),
                    ],
                  ),
                  feedAsync.maybeWhen(
                    data: (feeds) {
                      final feedList = feeds.feeds.toList();
                      while (feedList.length < 3) {
                        feedList.add(Feed.empty());
                      }
                      return _PopularAuthorThumbnailView(feeds: feedList);
                    },
                    orElse: () => Skeletonizer(child: _PopularAuthorThumbnailView(feeds: Feed.emptyList)),
                  ),
                ],
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(visibleUserCount, (index) {
            final isActive = index == currentIndex.value;
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? AppColor.gray700 : AppColor.gray400),
            );
          }),
        ),
      ],
    );
  }
}

class _PopularAuthorThumbnailView extends StatelessWidget {
  const _PopularAuthorThumbnailView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children:
          feeds
              .map(
                (feed) => Expanded(
                  child: AspectRatio(aspectRatio: 1.0, child: GrimityImage.small(imageUrl: feed.thumbnail ?? '')),
                ),
              )
              .toList(),
    );
  }
}
