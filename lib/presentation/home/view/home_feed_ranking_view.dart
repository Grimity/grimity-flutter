import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/grimity_image_feed.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeFeedRankingView extends ConsumerWidget {
  const HomeFeedRankingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedRanking = ref.watch(feedRankingDataProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('오늘의 인기 랭킹', style: AppTypeface.subTitle1),
              Text('더보기', style: AppTypeface.caption1.copyWith(color: AppColor.gray600)),
            ],
          ),
        ),
        const Gap(16),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: feedRanking.maybeWhen(
            data: (data) => _HomeRankingCarousel(feeds: data),
            orElse: () => Skeletonizer(child: _HomeRankingCarousel(feeds: Feed.emptyList)),
          ),
        ),
      ],
    );
  }
}

class _HomeRankingCarousel extends StatelessWidget {
  const _HomeRankingCarousel({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: feeds.length,
      options: CarouselOptions(
        enableInfiniteScroll: false,
        disableCenter: true,
        viewportFraction: 0.6,
        padEnds: false,
        height: 300,
      ),
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(right: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                child: GrimityImageFeed(feed: feeds[itemIndex], index: itemIndex),
              );
            },
          ),
        );
      },
    );
  }
}
