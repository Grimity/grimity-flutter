import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/ranking/provider/popular_feed_ranking_option_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 인기 그림 순위에 대한 월 선택을 위한 바텀 시트
class MonthPickerBottomSheet extends HookConsumerWidget {
  const MonthPickerBottomSheet({
    super.key,
    required this.initYear,
    required this.initMonth,
  });

  final int initYear;
  final int initMonth;

  static Future<void> show(DateTime baseDate) {
    final year = baseDate.year;
    final month = baseDate.month;

    final bottomSheet = GdsBottomSheet(
      title: '',
      child: MonthPickerBottomSheet(
        initYear: year,
        initMonth: month,
      ),
    );

    assert(rootNavigatorKey.currentContext != null);
    return bottomSheet.open(rootNavigatorKey.currentContext!);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedYear = useState(initYear);
    final colors = context.gdsColors;
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: GdsSpacing.spacing8,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: GdsSpacing.spacing8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GdsIconButton.normal(
                onPressed: () => selectedYear.value--,
                icon: GdsIcon.chevronLeft,
              ),
              Text(
                '${selectedYear.value}',
                style: GdsTypography.label1.copyWith(color: colors.text.grayBold),
              ),
              GdsIconButton.normal(
                onPressed: () => selectedYear.value++,
                icon: GdsIcon.chevronRight,
              ),
            ],
          ),
        ),
        DynamicHeightGridView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: GdsSpacing.spacing6,
          crossAxisSpacing: GdsSpacing.spacing6,
          itemCount: 12,
          builder: (context, index) {
            final year = selectedYear.value;
            final month = index + 1;
            final isSelected = selectedYear.value == initYear && month == initMonth;
            final isDisabled = selectedYear.value > now.year || (selectedYear.value == now.year && month > now.month);

            return GdsListItem.pickerCard(
              text: '$month월',
              state:
                  isSelected
                      ? GdsListItemState.pressed
                      : isDisabled
                      ? GdsListItemState.disabled
                      : GdsListItemState.enabled,
              onTap: () {
                context.pop();
                ref.read(popularFeedRankingOptionProvider.notifier).setBaseDate(year, month);
              },
            );
          },
        ),
      ],
    );
  }
}
