import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/date_time_extension.dart';
import 'package:grimity/presentation/home/widgets/home_section.dart';

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
          onMore: () {}, // TODO
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

                return SingleChildScrollView(
                  scrollDirection: .horizontal,
                  clipBehavior: .none,
                  child: Row(
                    spacing: spacing,
                    children: feeds.indexedBuilder((index, feed) {
                      return SizedBox(
                        width: width,
                        child: buildFeed(index, feed),
                      );
                    }),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// 주간 랭킹의 각 피드를 앨범 카드로 표시하는 빌더.
  Widget buildFeed(int index, FeedRankingResponse feed) {
    return GdsAlbum(
      rank: index + 1,
      image: feed.thumbnail.responsiveImage,
      title: feed.title,
      nickname: feed.author.name,
      likeCount: feed.likeCount.toInt(),
      viewCount: feed.viewCount.toInt(),
      like: feed.isLike,
      onTap: () {}, // TODO
      onLike: (_) {}, // TODO
    );
  }
}
