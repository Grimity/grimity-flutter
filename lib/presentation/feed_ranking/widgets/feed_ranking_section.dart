import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 인기 그림 랭킹 화면의 섹션 제목과 콘텐츠를 표시하는 위젯.
class FeedRankingSection extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        spacing: context.whenDevice(
          mobile: 16,
          tablet: 24,
        ),
        children: [
          // 제목 표시
          GdsText(
            title,
            color: .textGrayBold,
            style: context.whenDevice(
              mobile: .title2,
              tablet: .title1,
            ),
          ),

          // 본문 표시
          child,
        ],
      ),
    );
  }
}
