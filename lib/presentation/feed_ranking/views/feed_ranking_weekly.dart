import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/feed_ranking/pages/feed_ranking_page.dart';
import 'package:grimity/presentation/feed_ranking/widgets/feed_ranking_period.dart';
import 'package:grimity/widgets/sliver_column.dart';
import 'package:grimity/widgets/sliver_feed_grid.dart';
import 'package:pervice/pervice.dart';

/// 주간 인기 그림과 조회 기간을 표시하고 이전과 다음 주로 이동할 수 있는 화면.
class FeedRankingWeekly extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 조회 시작일.
    final startDate = context.stateOf(() => today.subtract(const .new(days: 7)));

    // 조회 종료일.
    final endDate = context.stateOf(() => today);

    // 주간 인기 그림 서비스.
    final service = context.serviceOf(
      () => GetFeedsRankings(
        startDate: startDate.value.yearMonthDay,
        endDate: endDate.value.yearMonthDay,
      ),
      key: ValueKey((startDate.value, endDate.value)),
    );

    // 조회 기간의 시작일과 종료일을 표시할 문자열로 변환.
    final startDateLabel = startDate.value.dateLabel;
    final endDateLabel = endDate.value.dateLabel;

    return SliverColumn(
      spacing: context.whenDevice(
        mobile: 20,
        tablet: 24,
      ),
      children: [
        FeedRankingPeriod(
          // 일주일 앞으로 이동.
          onNext: () {
            startDate.value = startDate.value.add(const .new(days: 7));
            endDate.value = endDate.value.add(const .new(days: 7));
          },

          // 일주일 뒤로 이동.
          onPrevious: () {
            startDate.value = startDate.value.subtract(const .new(days: 7));
            endDate.value = endDate.value.subtract(const .new(days: 7));
          },

          // 오늘이 아닌지 여부.
          canNext: !endDate.value.isToday,

          // 출시일 이후인지 여부.
          canPrevious: startDate.value.isAfter(FeedRankingPage.releaseDate),

          // yyyy.MM.dd - yyyy.MM.dd 혹은 오늘.
          child: GdsText(
            '$startDateLabel - $endDateLabel',
            color: .textGrayBold,
            style: .label3,
          ),
        ),

        service.sliver(
          placeholder: FeedRankingPage.placeholder,
          builder: (data) {
            final feeds = data.feeds;

            return SliverFeedGrid(
              itemCount: feeds.length,
              itemBuilder: (context, index) {
                final feed = feeds[index];

                return (
                  id: feed.id,
                  thumbnail: feed.thumbnail,
                  title: feed.title,
                  nickname: feed.author.name,
                  likeCount: feed.likeCount.toInt(),
                  viewCount: feed.viewCount.toInt(),
                  isLike: feed.isLike,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
