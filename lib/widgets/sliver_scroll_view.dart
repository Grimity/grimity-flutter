import 'package:flutter/widgets.dart';
import 'package:grimity/widgets/sliver_column.dart';

/// 여러 슬리버에 공통 여백과 항목 간 간격을 적용하는 스크롤 위젯.
class SliverScrollView extends StatelessWidget {
  const new({
    super.key,
    this.spacing = 0,
    this.padding,
    required this.slivers,
  });

  final double spacing;
  final EdgeInsets? padding;
  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: padding ?? .zero,
          sliver: SliverColumn(
            spacing: spacing,
            children: slivers,
          ),
        ),
      ],
    );
  }
}
