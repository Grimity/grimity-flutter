import 'package:flexible_horizontal_list_view/flexible_horizontal_list_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_use_case.dart';
import 'package:grimity/extensions/date_time_extension.dart';
import 'package:grimity/presentation/feed_detail/pages/feed_detail_page.dart';
import 'package:grimity/presentation/home/widgets/home_section.dart';
import 'package:grimity/presentation/navigation/navigation_page.dart';
import 'package:pervice/pervice.dart';

/// 홈 화면에서 주간 랭킹 피드를 가로 형태의 앨범 카드 목록을 표시하는 위젯.
class HomeWeeklyRanking extends StatelessWidget {
  const new({
    super.key,
    required this.service,
  });

  final GetFeedsRankings service;

  /// 주간 랭킹을 불러오는 동안 표시할 임시 피드 데이터.
  static final placeholder = FeedRankingsResponse(
    feeds: List.generate(10, (_) {
      return .new(
        id: '',
        title: 'Placeholder',
        thumbnail: '',
        likeCount: 0,
        viewCount: 0,
        isLike: false,
        author: .new(id: '', name: 'Placeholder', url: ''),
      );
    }),
  );

  /// 오늘을 기준으로 최근 일주일의 피드 랭킹을 조회하는 서비스를 생성합니다.
  static GetFeedsRankings createService() {
    final now = DateTime.now();
    final startDate = now.subtract(.new(days: 7)); // 일주일 전
    final endDate = now;

    return .new(
      startDate: startDate.yearMonthDay,
      endDate: endDate.yearMonthDay,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: HomeSection(
        header: .new(
          title: '주간 랭킹',
          onMore: () {
            // 랭킹 페이지로 이동.
            NavigationPage.moveTo(context, 1);
          },
        ),
        child: service.builder(
          placeholder: placeholder,
          builder: (data) {
            final feeds = data.feeds;

            return LayoutBuilder(
              builder: (context, constraints) {
                // 주간 랭킹 카드의 너비를 피드 그리드의 열 개수와 간격에 맞춤.
                final maxWidth = constraints.maxWidth;
                final spacing = 16.0;
                final count = context.feedGridCrossAxisCount;
                final width = (maxWidth - spacing * (count - 1)) / count;

                return HorizontalListView.separated(
                  itemCount: feeds.length,
                  separatorBuilder: (context, index) => Gap(spacing),
                  clipBehavior: .none,

                  // 대용량 이미지로 인한 성능 이슈로 0 픽셀로 조정.
                  cacheExtent: 0,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: width,
                      child: buildFeed(context, index, feeds[index]),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// 주간 랭킹의 각 피드를 앨범 카드로 표시하는 빌더.
  Widget buildFeed(BuildContext context, int index, FeedRankingResponse feed) {
    final isLike = context.sharedStateOf(
      () => feed.isLike,
      key: ValueKey('feed-${feed.id}:is-like'),
    );

    final likeCount = context.sharedStateOf(
      () => feed.likeCount.toInt(),
      key: ValueKey('feed-${feed.id}:like-count'),
    );

    final viewCount = context.sharedStateOf(
      () => feed.viewCount.toInt(),
      key: ValueKey('feed-${feed.id}:view-count'),
    );

    return GdsAlbum(
      rank: index + 1,
      image: feed.thumbnail.toImage(),
      title: feed.title,
      nickname: feed.author.name,
      likeCount: likeCount.value,
      viewCount: viewCount.value,
      like: isLike.value,
      onTap: () {
        // 피드 상세 페이지로 이동.
        context.push(FeedDetailPage(id: feed.id));
      },
      onLike: (value) {
        AppUseCase.likeFeed(
          context,
          id: feed.id,
          value: value,
          isLike: isLike,
          likeCount: likeCount,
        );
      },
    );
  }
}
