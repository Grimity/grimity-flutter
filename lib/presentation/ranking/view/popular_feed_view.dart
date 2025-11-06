import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_feed_grid.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/ranking/provider/popluar_feed_data_provider.dart';
import 'package:grimity/presentation/ranking/provider/popular_feed_ranking_option_provider.dart';
import 'package:grimity/presentation/ranking/widget/month_picker_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 인기 그림 순위
class PopularFeedView extends ConsumerWidget {
  const PopularFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularFeed = ref.watch(popularFeedRankingDataProvider);
    final option = ref.watch(popularFeedRankingOptionProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('인기 그림 순위', style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800)),
          Gap(16),
          Row(
            spacing: 4,
            children:
                FeedRankingType.values
                    .map(
                      (type) => GrimityGesture(
                        onTap: () => ref.read(popularFeedRankingOptionProvider.notifier).setType(type),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                          decoration: BoxDecoration(
                            color: type == option.type ? AppColor.main : AppColor.gray00,
                            border: Border.all(
                              color: type == option.type ? Colors.transparent : AppColor.gray300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            type == FeedRankingType.weekly ? '주간' : '월간',
                            style: AppTypeface.label1.copyWith(
                              color: type == option.type ? AppColor.gray00 : AppColor.gray700,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          Gap(12),
          Container(
            padding: EdgeInsets.only(left: 16, right: 8, top: 6, bottom: 6),
            decoration: BoxDecoration(color: AppColor.gray200, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    Icon(Icons.calendar_month_rounded, color: AppColor.gray500),
                    option.type == FeedRankingType.weekly
                        ? Text(
                          '${option.baseDate.oneWeekBeforeFormatted} - ${option.baseDate.isSameDay(DateTime.now()) ? '오늘' : option.baseDate.toYearMonthDay}',
                          style: AppTypeface.label2.copyWith(color: AppColor.gray700),
                        )
                        : GrimityGesture(
                          onTap: () => MonthPickerBottomSheet.show(context, option.baseDate),
                          child: Row(
                            spacing: 6,
                            children: [
                              Text(
                                option.baseDate.toMonthText,
                                style: AppTypeface.label2.copyWith(color: AppColor.gray700),
                              ),
                              Assets.icons.common.arrowDown.svg(
                                width: 16,
                                colorFilter: ColorFilter.mode(AppColor.gray700, BlendMode.srcIn),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
                Row(
                  spacing: 12,
                  children: [
                    GrimityGesture(
                      onTap:
                          option.isPreviousAvailable
                              ? () => ref.read(popularFeedRankingOptionProvider.notifier).goToPrevious()
                              : null,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColor.gray00,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColor.gray300, width: 1),
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          size: 18.w,
                          color: option.isPreviousAvailable ? null : AppColor.gray300,
                        ),
                      ),
                    ),
                    GrimityGesture(
                      onTap:
                          option.isNextAvailable
                              ? () => ref.read(popularFeedRankingOptionProvider.notifier).goToNext()
                              : null,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColor.gray00,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColor.gray300, width: 1),
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          size: 18.w,
                          color: option.isNextAvailable ? null : AppColor.gray300,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(16),
          popularFeed.when(
            data: (feeds) => feeds.isEmpty ? SizedBox.shrink() : _PopularFeedListView(feeds: feeds),
            loading: () => Skeletonizer(child: _PopularFeedListView(feeds: Feed.emptyList)),
            error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(popularFeedRankingDataProvider)),
          ),
        ],
      ),
    );
  }
}

class _PopularFeedListView extends ConsumerWidget {
  const _PopularFeedListView({required this.feeds});

  final List<Feed> feeds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GrimityFeedGrid(
      feeds: feeds,
      onToggleLike:
          (feed) => ref
              .read(popularFeedRankingDataProvider.notifier)
              .toggleLike(feedId: feed.id, like: feed.isLike == true ? false : true),
    );
  }
}
