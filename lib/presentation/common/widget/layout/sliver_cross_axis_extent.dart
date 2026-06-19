import 'package:flutter/widgets.dart';

/// 해당 위젯은 스크롤 내부의 가로 크기를 제한하고 이를 중앙으로 정렬합니다.
class SliverCrossAxisExtent extends StatelessWidget {
  const SliverCrossAxisExtent({
    super.key,
    required this.maxExtent,
    required this.sliver,
  });

  final double maxExtent;
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        if (constraints.crossAxisExtent > maxExtent) {
          return SliverCrossAxisGroup(
            slivers: [
              const SliverCrossAxisExpanded(flex: 1, sliver: SliverToBoxAdapter()),
              SliverConstrainedCrossAxis(
                maxExtent: maxExtent,
                sliver: sliver,
              ),
              const SliverCrossAxisExpanded(flex: 1, sliver: SliverToBoxAdapter()),
            ],
          );
        }

        return sliver;
      },
    );
  }
}
