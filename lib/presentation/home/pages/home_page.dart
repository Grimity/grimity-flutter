import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/home/views/home_banner.dart';
import 'package:grimity/presentation/home/views/home_free_board.dart';
import 'package:grimity/presentation/home/views/home_latest_feeds.dart';
import 'package:grimity/presentation/home/views/home_notice_board.dart';
import 'package:grimity/presentation/home/views/home_weekly_ranking.dart';
import 'package:grimity/presentation/navigation/navigation_view.dart';
import 'package:grimity/widgets/sliver_row.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 주간 랭킹, 게시판 최신 글과 최신 그림을 모아 표시하는 홈 페이지.
class HomePage extends StatelessWidget with NavigationView {
  const new({super.key});

  @override
  GdsIcon get icon => .home;

  @override
  String get label => '홈';

  @override
  Widget build(BuildContext context) {
    final weeklyRankingService = context.serviceOf(
      HomeWeeklyRanking.createService,
      key: ValueKey(HomeWeeklyRanking),
    );

    final freeBoardService = context.serviceOf(
      HomeFreeBoard.createService,
      key: ValueKey(HomeFreeBoard),
    );

    final noticeBoardService = context.serviceOf(
      HomeNoticeBoard.createService,
      key: ValueKey(HomeNoticeBoard),
    );

    final latestFeedsService = context.serviceOf(
      HomeLatestFeeds.createService,
      key: ValueKey(HomeLatestFeeds),
    );

    return GdsPullToRefresh(
      onRefresh: () => Future.wait([
        weeklyRankingService.refresh(),
        freeBoardService.refresh(),
        noticeBoardService.refresh(),
        latestFeedsService.refresh(),
      ]),
      child: GdsInfiniteScroll(
        onLoadMore: latestFeedsService.loadMore,
        enabled: latestFeedsService.canLoreMore,
        child: SliverScrollView(
          spacing: context.whenDevice(
            mobile: 32.0,
            tablet: 40.0,
          ),
          padding: context.whenDevice(
            mobile: 16.all,
            tablet: 20.all,
          ),
          slivers: [
            // 이용 규칙 배너 표시
            const HomeBanner(),

            // 주간 랭킹 표시
            HomeWeeklyRanking(service: weeklyRankingService),

            // 태블릿은 가로로 묶어서 표시
            if (context.isTablet) ...[
              SliverRow(
                spacing: 16,
                children: [
                  // 자유 게시판 표시
                  HomeFreeBoard(service: freeBoardService),

                  // 공지 게시판 표시
                  HomeNoticeBoard(service: noticeBoardService),
                ],
              ),
            ] else ...[
              // 자유 게시판 표시
              HomeFreeBoard(service: freeBoardService),

              // 공지 게시판 표시
              HomeNoticeBoard(service: noticeBoardService),
            ],

            // 최신 그림 표시
            HomeLatestFeeds(service: latestFeedsService),
          ],
        ),
      ),
    );
  }
}
