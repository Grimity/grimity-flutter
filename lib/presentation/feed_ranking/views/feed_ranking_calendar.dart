import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/feed_ranking/pages/feed_ranking_page.dart';
import 'package:pervice/pervice.dart';

/// 연도별 월 선택 카드를 표시하는 인기 그림 조회 기간 선택 위젯.
class FeedRankingCalendar extends StatelessWidget {
  const new({
    super.key,
    required this.initialDate,
    required this.onChanged,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final year = context.stateOf(() => initialDate.year);
    final now = DateTime.now();
    final nowMonth = DateTime(now.year, now.month);
    final releaseDate = FeedRankingPage.releaseDate;
    final releaseMonth = FeedRankingPage.releaseMonth;

    return Column(
      mainAxisSize: .min,
      spacing: 8,
      children: [
        Padding(
          padding: const .symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              // 이전 연도 버튼 표시.
              GdsButton.icon(
                type: .normal,
                icon: .chevronLeft,
                status: .from(enabled: year.value > releaseDate.year),
                onTap: () => year.value--,
              ),

              // 조회 연도 표시.
              GdsText('${year.value}', color: .textGrayBold, style: .label1),

              // 다음 연도 버튼 표시.
              GdsButton.icon(
                type: .normal,
                icon: .chevronRight,
                status: .from(enabled: year.value < now.year),
                onTap: () => year.value++,
              ),
            ],
          ),
        ),

        // 12개월을 3열의 선택 카드 형태로 표시.
        ...List.generate(4, (row) {
          return Row(
            spacing: 6,
            children: List.generate(3, (column) {
              final month = row * 3 + column + 1;
              final date = DateTime(year.value, month);
              final selected = year.value == initialDate.year && month == initialDate.month;
              final disabled = date.isBefore(releaseMonth) || date.isAfter(nowMonth);

              return Expanded(
                child: GdsListItem.pickerCard(
                  label: '$month월',
                  status: .from(
                    enabled: !disabled,
                    selected: selected,
                  ),
                  onTap: () => onChanged(date),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  /// 월 선택 바텀 시트를 열고 선택한 조회 월을 반환합니다.
  static Future<DateTime?> show(BuildContext context, DateTime initialDate) {
    final bottomSheet = GdsBottomSheet(
      onBack: context.pop,
      child: FeedRankingCalendar(
        initialDate: initialDate,
        onChanged: context.pop,
      ),
    );

    return bottomSheet.open(context);
  }
}
