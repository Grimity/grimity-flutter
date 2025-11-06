import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/ranking/provider/popular_feed_ranking_option_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 인그 그림 순위 월 선택 바텀 시트
class MonthPickerBottomSheet extends HookConsumerWidget {
  const MonthPickerBottomSheet({super.key, required this.initYear, required this.initMonth});

  final int initYear;
  final int initMonth;

  static void show(BuildContext context, DateTime baseDate) {
    final year = baseDate.year;
    final month = baseDate.month;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (BuildContext context) => MonthPickerBottomSheet(initYear: year, initMonth: month),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedYear = useState(initYear);
    final now = DateTime.now();

    return SizedBox(
      height: 450.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(24),
            Row(
              children: [
                GrimityGesture(onTap: () => selectedYear.value--, child: Icon(Icons.chevron_left, size: 26)),
                Gap(20),
                Text('${selectedYear.value}', style: AppTypeface.subTitle3.copyWith(color: AppColor.gray800)),
                Gap(20),
                GrimityGesture(onTap: () => selectedYear.value++, child: Icon(Icons.chevron_right, size: 26)),
                const Spacer(),
                GrimityGesture(
                  onTap: () => context.pop(),
                  child: Assets.icons.common.close.svg(width: 24, height: 24),
                ),
              ],
            ),
            Gap(24),
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 52,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final isSelected = selectedYear.value == initYear && month == initMonth;
                  final isDisabled =
                      selectedYear.value > now.year || (selectedYear.value == now.year && month > now.month);

                  return _MonthButton(
                    year: selectedYear.value,
                    month: month,
                    isSelected: isSelected,
                    isDisabled: isDisabled,
                  );
                },
              ),
            ),
            Gap(24),
          ],
        ),
      ),
    );
  }
}

class _MonthButton extends ConsumerWidget {
  const _MonthButton({required this.year, required this.month, required this.isSelected, required this.isDisabled});

  final int year;
  final int month;
  final bool isSelected;
  final bool isDisabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GrimityGesture(
      onTap:
          isDisabled
              ? null
              : () {
                context.pop();
                ref.read(popularFeedRankingOptionProvider.notifier).setBaseDate(year, month);
              },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? AppColor.main : AppColor.gray300, width: 1),
          borderRadius: BorderRadius.circular(12),
          color:
              isSelected
                  ? AppColor.main.withValues(alpha: 0.1)
                  : isDisabled
                  ? AppColor.gray200
                  : AppColor.gray00,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$month월', style: AppTypeface.label2.copyWith(color: AppColor.gray800)),
            if (isSelected)
              Assets.icons.common.checkMark.svg(
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(AppColor.main, BlendMode.srcIn),
              ),
          ],
        ),
      ),
    );
  }
}
