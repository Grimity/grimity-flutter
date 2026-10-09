import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 여러 슬리버를 세로로 배치하여 하나의 그룹으로 묶는 위젯.
class SliverColumn extends StatelessWidget {
  const new({
    super.key,
    this.spacing = 0,
    required this.children,
  });

  final GdsSpacing spacing;
  final List<Widget> children;

  /// 각 항목 사이에 [spacing]만큼의 세로 간격을 추가하는 슬리버.
  Widget get gap => SliverToBoxAdapter(child: spacing.verticalGap);

  @override
  Widget build(BuildContext context) {
    var slivers = children;

    // 간격이 존재한다면 각 항목 사이에 간격용 슬라이버 삽입.
    if (spacing > 0) {
      slivers = slivers.expand((element) => [element, gap]).toList()..removeLast();
    }

    return SliverMainAxisGroup(key: key, slivers: slivers);
  }
}
