import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/feed_ranking/pages/feed_ranking_page.dart';
import 'package:grimity/presentation/feed_ranking/views/feed_ranking_calendar.dart';
import 'package:grimity/presentation/feed_ranking/widgets/feed_ranking_period.dart';
import 'package:grimity/widgets/sliver_column.dart';
import 'package:grimity/widgets/sliver_feed_grid.dart';
import 'package:pervice/pervice.dart';

/// 월간 인기 그림과 조회 월을 표시하고 이전과 다음 달로 이동할 수 있는 화면.
class FeedRankingMonthly extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final nowMonth = DateTime(now.year, now.month);

    // 조회 시작일.
    final date = context.stateOf(() => nowMonth);

    // 월간 인기 그림 서비스.
    final service = context.serviceOf(
      () => GetFeedsRankings(month: date.value.yearMonth),
      key: ValueKey(date.value),
    );

    return SliverColumn(
      spacing: context.whenDevice(
        mobile: 20,
        tablet: 24,
      ),
      children: [
        FeedRankingPeriod(
          // 한달 앞으로 이동.
          onNext: () {
            date.value = DateTime(date.value.year, date.value.month + 1);
          },

          // 한달 뒤로 이동.
          onPrevious: () {
            date.value = DateTime(date.value.year, date.value.month - 1);
          },

          // 이번 달 이전인지 여부.
          canNext: date.value.isBefore(nowMonth),

          // 출시 월 이후인지 여부.
          canPrevious: date.value.isAfter(FeedRankingPage.releaseMonth),

          // 선택한 조회 월 표시.
          child: GdsFilter(
            variant: .text,
            label: date.value.yearMonthLabel,
            onTap: () async {
              final selectedDate = await FeedRankingCalendar.show(context, date.value);

              if (context.mounted && selectedDate != null) {
                date.value = selectedDate;
              }
            },
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
