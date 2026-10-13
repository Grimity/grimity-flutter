import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 인기 그림 랭킹 화면의 상단 헤더를 표시하는 위젯.
class FeedRankingHeader extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsContainer(
      width: .infinity,
      padding: context.whenDevice(
        mobile: .symmetric(vertical: 20, horizontal: 16),
        tablet: .symmetric(vertical: 24, horizontal: 20),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        spacing: 8,
        children: [
          // 제목 표시
          GdsText(
            '인기 그림 순위',
            color: .textGrayBold,
            style: context.whenDevice(
              mobile: .title2,
              tablet: .title1,
            ),
          ),

          // 부제목 표시
          GdsText(
            '인기 그림은 40위까지 노출됩니다',
            color: .textGraySubtle,
            style: .label6,
          ),
        ],
      ),
    );
  }
}
