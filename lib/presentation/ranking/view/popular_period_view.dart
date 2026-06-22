import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/presentation/ranking/provider/popular_feed_ranking_option_provider.dart';
import 'package:grimity/presentation/ranking/widget/month_picker_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PopularPeriodView extends ConsumerWidget {
  const PopularPeriodView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;
    final option = ref.watch(popularFeedRankingOptionProvider);
    final rankingNotifier = ref.read(popularFeedRankingOptionProvider.notifier);

    final baseDate = option.baseDate;
    final oneWeekBefore = baseDate.oneWeekBeforeFormatted;
    final endDateLabel = baseDate.isSameDay(DateTime.now()) ? '오늘' : baseDate.toYearMonthDay;
    final dateRange = '$oneWeekBefore - $endDateLabel';

    return Container(
      margin: EdgeInsets.only(
        top: GdsSpacing.spacing12,
        left: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
        right: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
        bottom: context.isMobile ? GdsSpacing.spacing20 : GdsSpacing.spacing24,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: GdsSpacing.spacing6,
          horizontal: GdsSpacing.spacing12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(GdsRadius.md),
          color: colors.surface.graySubtlest,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (option.type == FeedRankingType.weekly) ...[
              Text(
                dateRange,
                style: GdsTypography.label3.copyWith(color: colors.text.grayBold),
              ),
            ] else ...[
              GdsFilter(
                type: GdsFilterType.text,
                text: option.baseDate.toMonthText,
                onTap: () => MonthPickerBottomSheet.show(option.baseDate),
              ),
            ],

            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing4,
              children: [
                GdsOutlinedButton.icon(
                  size: GdsOutlinedButtonSize.small,
                  icon: GdsIcon.chevronLeft,
                  enabled: option.isPreviousAvailable,
                  onPressed: rankingNotifier.goToPrevious,
                ),
                GdsOutlinedButton.icon(
                  size: GdsOutlinedButtonSize.small,
                  icon: GdsIcon.chevronRight,
                  enabled: option.isNextAvailable,
                  onPressed: rankingNotifier.goToNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
