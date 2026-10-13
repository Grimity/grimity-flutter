import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 인기 그림 조회 기간과 이전과 다음 기간 이동 버튼을 표시하는 위젯.
class FeedRankingPeriod extends StatelessWidget {
  const new({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.canNext,
    required this.canPrevious,
    required this.child,
  });

  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool canNext;
  final bool canPrevious;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GdsContainer(
        padding: .symmetric(vertical: 6, horizontal: 12),
        radius: .md,
        color: .surfaceGraySubtlest,
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            child,

            Row(
              mainAxisSize: .min,
              spacing: 4,
              children: [
                // 이전으로 버튼 표시
                GdsButton.text(
                  type: .outlined,
                  size: .sm,
                  leadingIcon: .chevronLeft,
                  onTap: onPrevious,
                  status: canPrevious ? .enabled : .disabled,
                ),

                // 다음으로 버튼 표시
                GdsButton.text(
                  type: .outlined,
                  size: .sm,
                  leadingIcon: .chevronRight,
                  onTap: onNext,
                  status: canNext ? .enabled : .disabled,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
