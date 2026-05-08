import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/extension/async_value_extension.dart';
import 'package:grimity/app/extension/build_context_extension.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/widget/grimity_image_feed.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/layout/anti_broken.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:grimity/presentation/home/widget/home_section_header.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeFeedRankingView extends ConsumerWidget {
  const HomeFeedRankingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedRanking = ref.watch(feedRankingDataProvider);

    return Column(
      children: [
        HomeSectionHeader(
          title: '주간 랭킹',
          onMoreTap: () => RankingRoute().go(context),
        ),
        const SizedBox(height: GdsSpacing.spacing16),
        AntiSizedBroken(
          child: Padding(
            padding: const EdgeInsets.only(left: GdsSpacing.spacing12),
            child: feedRanking.fadeWhen(
              data: (data) => _HomeRankingCarousel(feeds: data),
              loading: () => Skeletonizer(child: _HomeRankingCarousel(feeds: Feed.createEmptyList(context))),
              error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(feedRankingDataProvider)),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeRankingCarousel extends HookWidget {
  const _HomeRankingCarousel({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context) {
    final rowCount = context.feedRowCount;
    final pageController = usePageController(viewportFraction: 1 / rowCount);

    if (feeds.isEmpty) {
      // 운영 서버에서는 주간 랭킹이 없을리가 없지만, 로직이 바뀌면서 피드가
      // 아예 비어있으면 예외가 발생하여 텍스트를 표기하도록 예외 처리를 함.
      return Padding(
        padding: const EdgeInsets.all(GdsSpacing.spacing16),
        child: Text(
          '주간 랭킹 없음',
          style: GdsTypography.label3.copyWith(color: context.gdsColors.text.graySubtle),
        ),
      );
    }

    return ExpandablePageView.builder(
      animationDuration: Duration.zero,
      animationCurve: Curves.linear,
      padEnds: false,
      itemCount: feeds.length,
      controller: pageController,
      itemBuilder: (context, index) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(right: GdsSpacing.spacing12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final feed = feeds[index];

              return SizedBox(
                width: constraints.maxWidth,
                child: GrimityImageFeed(
                  feed: feed,
                  index: index,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
