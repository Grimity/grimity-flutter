import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 게시글 목록의 페이지 이동 버튼을 표시하는 슬리버 위젯.
class SliverPostNavigation extends StatelessWidget {
  const new({
    super.key,
    required this.page,
    required this.totalCount,
    required this.onChanged,
  });

  /// 1부터 시작하는 현재 페이지 번호.
  final int page;

  /// 전체 게시글의 개수.
  final int totalCount;

  /// 선택한 페이지 번호를 1부터 시작하는 값으로 전달하는 콜백.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final pageCount = max(1, (totalCount / 10).ceil());

    return SliverToBoxAdapter(
      child: Center(
        child: GdsNavigation(
          // API의 페이지 번호를 0부터 시작하는 인덱스로 변환.
          index: page - 1,
          pageCount: pageCount,
          visibleCount: context.whenDevice(
            mobile: 5,
            tablet: 10,
          ),
          onChanged: (index) => onChanged(index + 1),
        ),
      ),
    );
  }
}
