import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/home/widgets/home_header.dart';
import 'package:grimity/widgets/sliver_column.dart';

/// 홈 화면에서 헤더 아래에 콘텐츠를 표시하는 섹션 위젯.
class HomeSection extends StatelessWidget {
  const new({
    super.key,
    required this.header,
    required this.child,
  });

  final HomeHeader header;
  final Widget child;

  /// 기기 유형에 따른 헤더와 콘텐츠 사이의 간격을 반환합니다.
  static double spacing(BuildContext context) {
    return context.whenDevice(
      mobile: 16,
      tablet: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      spacing: spacing(context),
      children: [header, child],
    );
  }

  /// 헤더 아래에 슬리버 [child]를 표시하는 섹션을 생성합니다.
  static Widget sliver({
    Key? key,
    required HomeHeader header,
    required Widget child,
  }) {
    return Builder(
      key: key,
      builder: (context) {
        return SliverColumn(
          spacing: spacing(context),
          children: [
            SliverToBoxAdapter(child: header),
            child,
          ],
        );
      },
    );
  }
}
