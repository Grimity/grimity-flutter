import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/provider/author_with_feeds_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/user_card/grimity_author_with_feeds_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 인기 작가
class PopularAuthorView extends ConsumerWidget {
  const PopularAuthorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorWithFeedsAsync = ref.watch(authorWithFeedsDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('인기 작가', style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800)),
        ),
        Gap(16),
        authorWithFeedsAsync.when(
          data:
              (authorWithFeedsList) =>
                  authorWithFeedsList.isEmpty
                      ? SizedBox.shrink()
                      : _PopularAuthorCarousel(authorWithFeedsList: authorWithFeedsList),
          loading: () => Skeletonizer(child: _PopularAuthorCarousel(authorWithFeedsList: AuthorWithFeeds.emptyList)),
          error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(authorWithFeedsDataProvider)),
        ),
      ],
    );
  }
}

class _PopularAuthorCarousel extends HookConsumerWidget {
  const _PopularAuthorCarousel({required this.authorWithFeedsList});

  final List<AuthorWithFeeds> authorWithFeedsList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final visibleUserCount = authorWithFeedsList.length > 5 ? 5 : authorWithFeedsList.length;

    return Column(
      spacing: 16,
      children: [
        CarouselSlider.builder(
          itemCount: visibleUserCount,
          options: CarouselOptions(
            enableInfiniteScroll: false,
            disableCenter: true,
            padEnds: false,
            viewportFraction: 0.92,
            onPageChanged: (index, reason) => currentIndex.value = index,
          ),
          itemBuilder: (context, index, realIndex) {
            final authorWithFeeds = authorWithFeedsList[index];

            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 16 : 4, right: index == visibleUserCount - 1 ? 16 : 4),
              child: GrimityAuthorWithFeedsCard(
                authorWithFeeds: authorWithFeeds,
                onFollowTab:
                    () => ref
                        .read(authorWithFeedsDataProvider.notifier)
                        .toggleFollow(
                          id: authorWithFeeds.user.id,
                          follow: authorWithFeeds.user.isFollowing == false ? true : false,
                        ),
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
